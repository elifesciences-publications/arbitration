% Script main_run_stats_report_contrasts_single_subject
% Computes and visualizes contrasts of interests and nuisance regressors
% F-contrasts to assess efficacy of physiological noise correction
%
%  main_run_stats_report_contrasts_single_subject
%
%
%   See also tapas_physio_report_contrasts
%
% Author:   Andreea Diaconescu & Lars Kasper
% Created:  2016-01-09
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: new_script2.m 354 2013-12-02 22:21:41Z kasperla $
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters to set (subjects, preproc-flavor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

paths = get_paths_wagad(); % dummy subject to get general paths

if ismac
    iSubjectArray = get_subject_ids(paths.data, 'test_')';
else
    iSubjectArray = get_subject_ids(paths.data)';
end

% manual setting...if you want to exclude any subjects
iSubjectArray = 3;%setdiff(iSubjectArray, [14]);

fnBatchStatsContrasts = fullfile(paths.code.batches, ...
    paths.code.batch.fnStatsContrasts);

useCluster = false;

iDesign   = 1; % GLM design matrix selection by Id See also get_paths_wagad which folder it is :-)

% initialise spm
spm_get_defaults('modality', 'FMRI');
if ~exist('cfg_files', 'file')
    spm_jobman('initcfg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over subjects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iSubj = iSubjectArray
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Load paths, setup matlabbatch for subject
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % load subject specific paths
    paths = get_paths_wagad(iSubj);
    
    
    %% Load template batch, change relevant subject-specific paths in batch & save
    
    clear matlabbatch;
    run(paths.code.batch.fnStatsContrasts);
    
    % update SPM.mat dir
    matlabbatch{1}.spm.stats.con.spmmat = paths.stats.fnSpmArray(iDesign);
    
    % save subject-specific batch in subject-folder, but as mat-file for
    % simplicity, and with a time stamp
    fnBatchSave = get_batch_filename_subject_timestamp(paths, 'fnStatsContrasts');
    save(fnBatchSave, 'matlabbatch');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run matlabbatch...either interactively or on cluster
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if useCluster
        % assemble script-m-file to be executed via new matlab instance
        % created on brutus node
        nameScriptBrutus = sprintf('run_%s_%s_%s', ...
            paths.code.batch.fnStatsContrasts(1:end-2), paths.idSubjBehav, ...
            stringDate);
        fileScriptBrutus = fullfile(paths.cluster.scripts, ...
            [nameScriptBrutus '.m']);
        
        % Script file has to run
        fid = fopen(fileScriptBrutus, 'w+');
        fprintf(fid, [ ...
            'addpath %s;\n' ...
            'spm_get_defaults(''modality'', ''FMRI'');\n' ...
            'spm_get_defaults(''cmdline'', 1);\n' ...
            'spm_jobman(''initcfg'');\n' ...
            'spm_jobman(''run'', ''%s'');\n' ...
            ], ...
            paths.code.spm, fnBatchSave);
        fclose(fid);
        
        % Submit execution of job to brutus]
        jobQueue = 'vip';
        switch jobQueue
            case 'vip' % asks for more memory
                cmdSubmit = sprintf(['cd %s; bsub -q vip.36h -R "rusage[mem=8192]" -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
                    '-r %s; cd %s'], paths.cluster.scripts, ...
                    nameScriptBrutus, nameScriptBrutus, pwd);
            case 'pub'
                cmdSubmit = sprintf(['cd %s;bsub -q pub.1h -o lsf.%s_o%%J matlab -nodisplay -nojvm -singleCompThread ' ...
                    '-r %s; cd %s'], paths.cluster.scripts, ...
                    nameScriptBrutus, nameScriptBrutus, pwd);
        end
        disp(cmdSubmit);
        unix(cmdSubmit);
        
    else
        spm_jobman('interactive', matlabbatch);
    end
    
end