%-----------------------------------------------------------------------
% Job saved on 04-Jan-2016 19:39:59 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'Parent Directory for Quality Report';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {'<UNDEFINED>'};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent(1) = cfg_dep('Named Directory Selector: Parent Directory for Quality Report(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = '<UNDEFINED>';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Functional Image Time Series';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Structural Image';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{5}.spm.spatial.realign.write.data(1) = cfg_dep('Named File Selector: Functional Image Time Series(1) - Files', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{5}.spm.spatial.realign.write.roptions.which = [2 0];
matlabbatch{5}.spm.spatial.realign.write.roptions.interp = 4;
matlabbatch{5}.spm.spatial.realign.write.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.realign.write.roptions.mask = 1;
matlabbatch{5}.spm.spatial.realign.write.roptions.prefix = 'resliceReport';
matlabbatch{6}.spm.util.imcalc.input(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{6}.spm.util.imcalc.output = 'mean';
matlabbatch{6}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''<UNDEFINED>''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{6}.spm.util.imcalc.expression = 'mean(X)';
matlabbatch{6}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{6}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{6}.spm.util.imcalc.options.mask = 0;
matlabbatch{6}.spm.util.imcalc.options.interp = -4;
matlabbatch{6}.spm.util.imcalc.options.dtype = 16;
matlabbatch{7}.spm.util.imcalc.input(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{7}.spm.util.imcalc.output = 'sd';
matlabbatch{7}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''<UNDEFINED>''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{7}.spm.util.imcalc.expression = 'std(X)';
matlabbatch{7}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{7}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{7}.spm.util.imcalc.options.mask = 0;
matlabbatch{7}.spm.util.imcalc.options.interp = -4;
matlabbatch{7}.spm.util.imcalc.options.dtype = 16;
matlabbatch{8}.spm.util.imcalc.input(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{8}.spm.util.imcalc.output = 'snr';
matlabbatch{8}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''<UNDEFINED>''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{8}.spm.util.imcalc.expression = 'rdivide(mean(X),std(X))';
matlabbatch{8}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{8}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{8}.spm.util.imcalc.options.mask = 0;
matlabbatch{8}.spm.util.imcalc.options.interp = -4;
matlabbatch{8}.spm.util.imcalc.options.dtype = 16;
matlabbatch{9}.spm.util.imcalc.input(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{9}.spm.util.imcalc.output = 'diffOddEven';
matlabbatch{9}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''<UNDEFINED>''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{9}.spm.util.imcalc.expression = 'mean(X(1:2:end,:)) - mean(X(2:2:end,:))';
matlabbatch{9}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{9}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{9}.spm.util.imcalc.options.mask = 0;
matlabbatch{9}.spm.util.imcalc.options.interp = -4;
matlabbatch{9}.spm.util.imcalc.options.dtype = 16;
matlabbatch{10}.spm.util.imcalc.input(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{10}.spm.util.imcalc.output = 'maxAbsDiff';
matlabbatch{10}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''<UNDEFINED>''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{10}.spm.util.imcalc.expression = 'max(abs(diff(X)))';
matlabbatch{10}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{10}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{10}.spm.util.imcalc.options.mask = 0;
matlabbatch{10}.spm.util.imcalc.options.interp = -4;
matlabbatch{10}.spm.util.imcalc.options.dtype = 16;
matlabbatch{11}.spm.util.checkreg.data(1) = cfg_dep('Named File Selector: Structural Image(1) - Files', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{11}.spm.util.checkreg.data(2) = cfg_dep('Image Calculator: Imcalc Computed Image: mean', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.util.checkreg.data(3) = cfg_dep('Image Calculator: Imcalc Computed Image: sd', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.util.checkreg.data(4) = cfg_dep('Image Calculator: Imcalc Computed Image: snr', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.util.checkreg.data(5) = cfg_dep('Image Calculator: Imcalc Computed Image: diffOddEven', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{11}.spm.util.checkreg.data(6) = cfg_dep('Image Calculator: Imcalc Computed Image: maxAbsDiff', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{12}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir(1) = cfg_dep('Named Directory Selector: Parent Directory for Quality Report(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{13}.spm.util.print.fname = 'report_quality.ps';
matlabbatch{13}.spm.util.print.fig.figname = 'Graphics';
matlabbatch{13}.spm.util.print.opts = 'ps';
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;