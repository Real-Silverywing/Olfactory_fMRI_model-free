% Split the positive and negative  sdelta_hmap into only posi or neg
%Input: posineg_sdelta_hmap01_wfilterpp3{roi name}.nii 
%output: create posi_neg_ROI folder
%            (m)posi_roiname.nii: positively related(0/1), m menas masked
%            (m)neg_roiname.nii: negatively related(0/1), m menas masked
%            voxelNumber_posi-neg01_roiname.mat: number of voxel which is
%            posi/neg in this roi. Two variable in the mat: indexp for positive, indexn
%            for negative.
clear
roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Amy_exPiri_AAL','Insula_AAL','OFC_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
% wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
cd(wkdir) 
ROIdir = [wkdir,'ROI\'];

datasdir=dir('./*RA.ica');
datadir = [wkdir,datasdir.name];

for i =1:length(roiname)
    
    

    
    cd(datadir)    
    P = spm_select('FPlist',pwd,['^posineg.*wfilt.*',roiname{i},'.*.nii']);


    tmp = load_untouch_nii(P);
    img=tmp.img;
    img(img<0) = 0;
    posi_img = img; % only 0 and 1

    img=tmp.img;
    img(img>0) = 0;
    neg_img = img; % only 0 and -1
    
    if ~exist('posi_neg_ROI','dir')
        mkdir('posi_neg_ROI')
    end
    tmp.img = posi_img;
    save_fakeuntouch_nii(tmp,['posi_',roiname{i},'.nii']);
    tmp.img = abs(neg_img);
    save_fakeuntouch_nii(tmp,['neg_',roiname{i},'.nii']);
    
    
    maskname =spm_select('FPlist',ROIdir,['^',roiname{i},'.*.nii']);
    roifile =spm_select('list',pwd,['^posi_',roiname{i},'.nii']);
    matlabbatch{1}.spm.util.imcalc.input = {
        roifile
        maskname
        };
    matlabbatch{1}.spm.util.imcalc.output = ['m',roifile];
    matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
    matlabbatch{1}.spm.util.imcalc.expression = ['i1.*(i2>0.0005)'];
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',matlabbatch)
    
    x = spm_select('FPlist',pwd,['^mposi_',roiname{i},'.nii']);
    y = load_untouch_nii(x);
    img = y.img;
    index = find(img>0);
    indexp = length(index);
      
%     save(['voxeln_posi01',num2str(thr),'_',roiname{i},'.mat'],'indexp');
    
    roifile =spm_select('list',pwd,['^neg_',roiname{i},'.nii']);
    
    matlabbatch{1}.spm.util.imcalc.input = {
        roifile
        maskname
        };
    matlabbatch{1}.spm.util.imcalc.output = ['m',roifile];
    matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
    matlabbatch{1}.spm.util.imcalc.expression = ['i1.*(i2>0.0005)'];
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',matlabbatch)
    x = spm_select('FPlist',pwd,['^mneg_',roiname{i},'.nii']);
    
    y = load_untouch_nii(x);
    img = y.img;
    index = find(img>0);
    indexn = length(index);
    save(['posi_neg_ROI\','voxelNumber_posi-neg01_',roiname{i},'.mat'],'indexp','indexn');
    
    
end
fmp = dir('mposi*.nii');
fmn = dir('mneg*.nii');
fp = dir('posi*.nii');
fn = dir('neg*.nii');
for i = 1:length(roiname)
    movefile(fmp(i).name, [pwd,'\posi_neg_ROI\']);
    movefile(fmn(i).name, [pwd,'\posi_neg_ROI\']);
    movefile(fp(i).name, [pwd,'\posi_neg_ROI\']);
    movefile(fn(i).name, [pwd,'\posi_neg_ROI\']);
end

