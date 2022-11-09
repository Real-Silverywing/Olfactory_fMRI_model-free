%generate the mask for the significant voxels within olf ROIs.
%input: hmap_wfilterpp3_01.nii,
%       olf ROI masks (total of 15, @ROI folder)
%output: ROI_hmap01_*.nii (total of 15, in /KS), which are the intersection of hmap and olf ROIs: 

clear
%pool=parpool('ComputeNode');
spm('defaults','fmri');
% wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
cd(wkdir)
% datasdir=dir('./*.ica');
datasdir=dir('./*RA.ica');
%datadir=dir('./20210729*WW*.ica');


all = {datasdir.name};

ROIdir = [wkdir,'ROI\'];
roiname1 = {'Insula_AAL','OFC_AAL','MNI_OB_manual2'};%,'ob_new'};%'Olfactory_AAL',
roiname2 = {'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL'...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
roiname3 = {'Amy_exPiri_AAL','Figure_1B_MNI152_ROI_1mm'};
roiname = [roiname1,roiname2,roiname3];
% roiname = [roiname3];



prefix = 'wfilterpp3';

% make roi nii
for n=1:length(all)
    
    datadir = [wkdir,all{n}];
    cd(datadir)
    
    if ~exist('KS', 'dir')
        mkdir('KS')
    end
    KSdir = [wkdir,all{n},'\KS'];
        for r = 1:length(roiname) %roi
            
%             roi_file = spm_select('FPlist','/g5/kirby/xmiao5/XZhou86/ROI',['^',roiname{r},'.nii']);
            roi_file = spm_select('FPlist',ROIdir,['^',roiname{r},'.nii']);
            P = spm_select('ExtFPlist',pwd,['^hmap_',prefix,'_01.*.nii'],1);
%             check = size(P)
%             if check(1)~= 1
%                 error('Error. \nInput must be a char, not a %s.',[pwd,'^hmap_.*',prefix,'01.*.nii'])
%             end
            matlabbatch{1}.spm.util.imcalc.input = {
                P
                roi_file
                };
            matlabbatch{1}.spm.util.imcalc.output = ['ROI_hmap01_',prefix,roiname{r}];
%             matlabbatch{1}.spm.util.imcalc.outdir = {[wkdir,all{n},'/KS']};
            matlabbatch{1}.spm.util.imcalc.outdir = {KSdir};
            matlabbatch{1}.spm.util.imcalc.expression = ['i1.*(i2>0.0005)'];
            matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{1}.spm.util.imcalc.options.mask = 0;
            matlabbatch{1}.spm.util.imcalc.options.interp = 1;
            matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
            spm_jobman('run',matlabbatch)
            
        end
    
end
