clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
ROIdir = [wkdir,'ROI\'];
roiname1 = {'Insula_AAL','OFC_AAL','MNI_OB_manual2'};%,'ob_new'};%'Olfactory_AAL',
roiname2 = {'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL'...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
roiname3 = {'Amy_exPiri_AAL','Figure_1B_MNI152_ROI_1mm'};
roiname = [roiname1,roiname2,roiname3];

root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'
estimate_path = '1st_norm/';
estimate = {dir('./1st_norm/*7T*').name};

%%
for n = 1:length(estimate)
    
    tfiledir = fullfile(root, estimate_path,estimate{n});
    tfile_name = spm_select('FPlist',tfiledir,'spmT_0001.nii');
    
    cd (tfiledir)
    if ~exist('\mask', 'dir')
        mkdir('mask')
    end
    maskdir = fullfile(tfiledir,'mask');
    for r = 1:length(roiname) %roi
        roi_file = spm_select('FPlist',ROIdir,['^',roiname{r},'.nii']);
%         P = spm_select('ExtFPlist',pwd,['^hmap_',prefix,'_01.*.nii'],1);
        P = spm_select('FPlist',tfiledir,'spmT_0001.nii');
%             check = size(P)
%             if check(1)~= 1
%                 error('Error. \nInput must be a char, not a %s.',[pwd,'^hmap_.*',prefix,'01.*.nii'])
%             end
        matlabbatch{1}.spm.util.imcalc.input = {
            P
            roi_file
            };
        matlabbatch{1}.spm.util.imcalc.output = ['ROI_tmap01_',roiname{r}];
        matlabbatch{1}.spm.util.imcalc.outdir = {maskdir};
        matlabbatch{1}.spm.util.imcalc.expression = ['i1.*(i2>0.0005)'];
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
        spm_jobman('run',matlabbatch)

    end

 
    
end

%% mask size inconsistent with image size
shape = {};
for r = 1:length(roiname) %roi
    roi_file = spm_select('FPlist',ROIdir,['^',roiname{r},'.nii']);
    roinii = load_untouch_nii(roi_file);
    roi = roinii.img;
    shape(r) = {size(roi)};
end


