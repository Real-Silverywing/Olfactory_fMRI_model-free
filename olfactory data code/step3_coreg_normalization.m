%-----------------------------------------------------------------------
%This script is to coreg the anatomic image to the mean functional image,
%and then segment the structural iamge, and then normalize the functional
%ones (filterpp3_denoised.nii) to the MNI space. 
%Input: structual images in each subject's folder,%
%       /.*ica/mean.nii(mean_func.nii)
%       /*.ica/filterpp3_denoised.nii
%Output: wfilterpp3_denoised.nii
%        some segmentation result in structure folder
%-----------------------------------------------------------------------
clear
%pool=parpool('ComputeNode');
spm('defaults','fmri');
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
%wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
%wkdir = '//godzilla.kennedykrieger.org/g5/kirby/xmiao5/';
cd(wkdir)
%datadir=dir('./*.ica');
datasdir=dir('./*RA.ica');
all = {datasdir.name};
prefix='filterpp3';
%%
for n=1:length(all)
  
    exist_list = [];% which ica is done in this step
    datadir = [wkdir,all{n}];
    %structural data path: 1:end-4 means delete the '.ica' in the filename
    anatomic_datadir = [wkdir,all{n}(1:length(all{n})-4)];
    cd(datadir)
    %x = spm_select('FPlist',pwd,['c1.*nii']); %check if the data has run before, c1 white matter segmentation
    x = spm_select('FPlist',pwd,['^wfilterpp3_denoised.nii']);
    if isempty(x)
        exist_list = [exist_list,all(n)];
        P = spm_select('FPlist',pwd,['^',prefix,'.*.nii']);
        %pstruc = spm_select('ExtFPlist',anatomic_datadir,'^20.*.nii');  %select structural data
        pstruc = spm_select('ExtFPlist',anatomic_datadir,'^20.*7_1.nii');  %select structural data
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = {['mean_func.nii,1']};
        matlabbatch{1}.spm.spatial.coreg.estimate.source = {pstruc};
        matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
       
        matlabbatch{2}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
        matlabbatch{2}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{2}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{2}.spm.spatial.preproc.channel.write = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,1'};
        matlabbatch{2}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{2}.spm.spatial.preproc.tissue(1).native = [1 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,2'};
        matlabbatch{2}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{2}.spm.spatial.preproc.tissue(2).native = [1 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,3'};
        matlabbatch{2}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{2}.spm.spatial.preproc.tissue(3).native = [1 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,4'};
        matlabbatch{2}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{2}.spm.spatial.preproc.tissue(4).native = [1 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,5'};
        matlabbatch{2}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{2}.spm.spatial.preproc.tissue(5).native = [1 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\zhoux\Documents\MATLAB\spm12\tpm\TPM.nii,6'};
        matlabbatch{2}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{2}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{2}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{2}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{2}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{2}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{2}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{2}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{2}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{2}.spm.spatial.preproc.warp.write = [1 1];
        
        
        pmatrix = spm_select('FPlist',anatomic_datadir,['^y_.*.nii']);%check segmentation existence? 
        if isempty(pmatrix)
            spm_jobman('run',matlabbatch);
            pmatrix = spm_select('FPlist',anatomic_datadir,'^y_.*.nii'); %generated in the segamentation
        end
        clear matlabbatch
        
        fimg = spm_select('ExtFPlist',pwd,['^',prefix,'_d.*nii'],Inf);
        
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {pmatrix};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(fimg); %fimg
        
        
        
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
            90 90 108];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1.5 1.5 1.5];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
        spm_jobman('run',matlabbatch);
        
        
    end
    
    spm_jobman('run',matlabbatch); %?
end

