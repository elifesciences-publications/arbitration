function [] = wagad_extract_roi_timeseries(idxSubjectArray)
% Extract roi time series from regions of interest (group effect regions)
%   Uses UniQC Toolbox for dealing with fMRI time series and ROI extraction
% USE
%   wagad_extract_roi_timeseries(idxSubjectArray)

if nargin < 1
    idxSubjectArray = setdiff([3:47], [6 14 25 31 32 33 34 37]);
end

%% #MOD user defined-parameters
doPlotRoi       = true;
idxMaskArray    = [4 4]; % mask indices to be used from fnMaskArray
idxContrastArray= [3; 1; 1; 1]; % determines 2nd level dir where the activation mask can be found
idxRunArray     = [1 2]; % concatenated runs [1 2]

% number sampled time bins per trial after epoching,
% default:7, because ITI <= 16s (< 7 TR)
% note: number of included trials is adapted to number of bins, if last
% trials are too short wrt nBinTimes*TR
nBinTimes       = 7;

% cell of cluster index vectors corresponding to each mask
% each integer is an index for n-ary cluster export of a contrast,
% indicating which activated cluster is indeed within the targeted
% anatomical region
idxValidActivationClusters  = {[1 3], [1 3]};
iCondition                  = 1; % 1 = advice presentation, needed fo trial binning
doPlotRoiUnbinned           = false; % plot before epoching
doUseParallelPool           = false; % set true on EULER to parallelize over subjects


%% derived parameters
nMasks = numel(idxMaskArray);
nRuns = numel(idxRunArray);
nSubjects = numel(idxSubjectArray);

if doUseParallelPool && isempty(gcp('noCreate'))
    % this is an interactive pool with more memory, i.e. additional command
    % line argument -R "rusage[mem=16000]" in cluster profile
    parpool('EulerLSF4h_16GB', nSubjects);
end

%% Subject loop for extraction and plotting of ROI time series for all
% runs and masks
% parfor
for iSubj = 1:nSubjects
    idxSubj = idxSubjectArray(iSubj);
    paths = get_paths_wagad(idxSubj);
    roiOpts = paths.stats.secondLevel.roiAnalysis; % short cut to substruct
    
    fnMaskArray = strcat(paths.stats.secondLevel.contrasts(idxContrastArray), ...
        filesep, roiOpts.fnMaskArray);
    
    %%
    epochedYArray = cell(nRuns,1);
    nValidTrialsPerRun = zeros(nRuns,1);
    for iRun = 1:nRuns
        fprintf('\n\tExtracting roi time series from subj %s (%d/%d), run %d ...', ...
            paths.idSubj, iSubj, nSubjects, iRun);
        fnFunct = regexprep(paths.preproc.output.fnFunctArray{idxRunArray(iRun)}, 'sw', 'w'); % use unsmoothed
        Y = MrImage(fnFunct);
        fprintf('loaded Y in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        %% Load SPM of subject to get timing info etc (for peri-stimulus binning
        % according to advice onsets
        % Get time bins (relative to trial onsets) for each volume
        % NOTE: The runs are concatenated in the GLM
        nVols = paths.scanInfo.nVols;
        
        iVolStart = 1 + sum(nVols(1:(iRun-1)));
        temp = load(paths.stats.fnSpm, 'SPM');
        SPM = temp.SPM;
        
        ons = SPM.Sess(1).U(iCondition).ons;
        TR = SPM.xY.RT;
        
        Y.dimInfo.set_dims('t', 'resolutions', TR, 'firstSamplingPoint', ...
            (iVolStart-1)*TR, 'samplingWidths', TR, 'units', 's');
        
        % select only onsets within timing range of this run
        idxTrialsWithinRun = find(ons >= Y.dimInfo.t.ranges(1) & ...
            ons <= Y.dimInfo.t.ranges(2) - TR*nBinTimes);
        ons = ons(idxTrialsWithinRun);
        nValidTrialsPerRun(iRun) = numel(idxTrialsWithinRun);
        
        %% Roi definition and extraction for full time series of run
        
        fprintf('computing masks in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        M = cell(1,nMasks);
        for iMask = 1:nMasks
            % remove other clusters (e.g., cholinergic), by there n-ary index
            M{iMask} = MrImage(fnMaskArray{idxMaskArray(iMask)});
            M{iMask}.data(~ismember(M{iMask}.data, idxValidActivationClusters{iMask})) = 0;
        end
        
        doKeepExistingRois = false;
        
        Y.extract_rois(M, doKeepExistingRois);
        Y.compute_roi_stats();
        
        %% Create an artificial MrImage for epoching, with one Roi-mean time series per slice
        % i.e. one Roi per slice, with 1 voxel
        % NOTE: mean over ROI voxels OK for later epoching, because data was
        % slice-timing corrected before; otherwise, slice-specific timing would
        % have to be included into epoching
        
        
        fprintf('epoching of Y in worker %d (id %s)\n', iSubj, paths.idSubj);
        
        
        
        dimInfoRoi = Y.dimInfo.copyobj;
        dimInfoRoi.set_dims({'x','y','z'}, 'nSamples', [1, 1, nMasks]);
        
        % permute to 4-dim to match dimensionality of dimInfo, which needs
        % x,y,z for epoching like SPM
        dataRoi = permute(cell2mat(cellfun(@(x) x.perVolume.mean, Y.rois, ...
            'UniformOutput', false)), [3 4 1 2]);
        Z = MrImage(dataRoi, 'dimInfo', dimInfoRoi);
        Z.name = sprintf('%s_mean_ts_one_roi_per_slice', paths.idSubj);
        
        % extract data from ROI and compute stats on that
        if doPlotRoiUnbinned
            Y.rois{1}.plot();  % time courses from roi and sd-bands
        end
        
        % now we only have to epoch a few voxels instead of the whole 3D volume
        % Epoch into trials
        epochedYArray{iRun} = Z.split_epoch(ons, nBinTimes);
        
        % right indices for trials to allow for proper concatenation
        % use relative indices (not absolute) to avoid inserting all-zero
        % time series for skipped trials
        epochedYArray{iRun}.dimInfo.set_dims('trials', 'samplingPoints', ...
            sum(nValidTrialsPerRun(1:(iRun-1))) + (1:nValidTrialsPerRun(iRun)));
        
    end % run
    
    epochedY = epochedYArray{1}.concat(epochedYArray, 'trials');
    
    %% handmade shaded PST-plot, averaged over trials
    for iMask = 1:nMasks
        idxMask = idxMaskArray(iMask);
        [~,~] = mkdir(roiOpts.results.rois{idxMask});
        
        [~,fnMaskShort] = fileparts(fnMaskArray{idxMaskArray(iMask)});
        stringTitle = sprintf(...
            'ROI %s (%s): Peristimulus plot, mean (over trials) +/- s.e.m time series', ...
            regexprep(fnMaskShort, '_', ' '), paths.idSubj);
        
        nVoxels = 1;% already a mean, otherwise: Y.rois{iMask}.perVolume.nVoxels;
        nTrials = epochedY.dimInfo.trials.nSamples;
        
        % data (mean ROI voxel time series) is [nMasks, nBins,nTrials] and has to be transformed
        % into [nTrials, nBins]) to do stats for plot
        y = permute(epochedY.select('z',iMask).remove_dims.data, [2, 1]);
        t = epochedY.dimInfo.t.samplingPoints{1};
        
        % baseline correction for drift etc:, and scale to mean == 100
        % remove height differences at trial-time = 0;
        y = 100./mean(y(:))*(y - y(:,1));
        
        % save for later plotting
        fprintf('parsave in worker %d (id %s)\n', iSubj, paths.idSubj);
        %parsave
        parsave_roi(...
            roiOpts.results.fnTimeSeriesArray{idxMask}, ...
            t,y,nVoxels,nTrials,stringTitle)
        
        if doPlotRoi
            fprintf('plotting in worker %d (id %s)\n', iSubj, paths.idSubj);
            fh = wagad_plot_roi_timeseries(t, y, nVoxels, nTrials, stringTitle);
            saveas(fh, roiOpts.results.fnFigureSubjectArray{idxMask});
        end
    end
end %for iSubj

end

 