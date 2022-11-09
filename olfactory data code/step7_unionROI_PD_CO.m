% Make common ROIs among subjects, the threshold of the common voxels are
%'thr', which is determined arbitrarily, I set it about half of the subject
%number. 
%Input: posineg*wfilterpp3*.nii of each olf ROI of all the subjects.
%output: mallCOposi*.nii/allCOneg*.nii (common ROIs
%       among subjects, masked with the olf ROIs)
%       voxeln_posi/neg*.mat  (voxel number of each common ROI)

clear
roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Amy_exPiri_AAL','Insula_AAL','OFC_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
thr = 5; %need to adjust, about half of the subj number. eg. 7 for ob and primary, amyg, 9 for the rest
for i =1:length(roiname)
    
    
    wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
    
    cd(wkdir)
    datadir=dir('**/20*.ica');
    %datadir=dir('./20210729*WW*.ica');

    all = {datadir.name};
    des = {datadir.folder};
    
    for  n=[(1:length(all))]
        
        
        P = spm_select('FPlist',[des{n},'/',all{n}],['^posineg.*wfilt.*',roiname{i},'.*.nii']);
        
        
        tmp = load_untouch_nii(P);
        %img(:,:,:,:,n) = tmp.img;
        img=tmp.img;
        img(img<0) = 0;
        pallimg(:,:,:,n) = img;
        
        img=tmp.img;
        img(img>0) = 0;
        nallimg(:,:,:,n) = img;
    end
    
    sump_allimg = sum(pallimg,4);
    
    sump_allimg(sump_allimg<thr) = 0;
    sump_allimg(sump_allimg>=thr) = 1;
    
    sumn_allimg = sum(nallimg,4);
    
    sumn_allimg(sumn_allimg>-thr) = 0;
    sumn_allimg(sumn_allimg<=-thr) = 1;
    
    cd('/g5/kirby/xmiao5/XZhou86/ROI')
    tmp.img = sump_allimg;
    save_fakeuntouch_nii(tmp,['allCOposi',num2str(thr),'_',roiname{i},'.nii']);
    tmp.img = sumn_allimg;
    save_fakeuntouch_nii(tmp,['allCOneg',num2str(thr),'_',roiname{i},'.nii']);
    
    
    maskname =spm_select('FPlist','/g5/kirby/xmiao5/XZhou86/ROI/',['^',roiname{i},'.*.nii']);
    roifile =spm_select('list',pwd,['^allCOposi',num2str(thr),'_',roiname{i},'.*.nii']);
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
    
    x = spm_select('FPlist',pwd,['^mall.*posi',num2str(thr),'.*',roiname{i},'.*.nii']);
    y = load_untouch_nii(x);
    img = y.img;
    index = find(img>0);
    indexp = length(index);
      
    save(['voxeln_allCOposi01',num2str(thr),'_',roiname{i},'.mat'],'indexp');
    
    roifile =spm_select('list',pwd,['^allCOneg',num2str(thr),'_',roiname{i},'.*.nii']);
    
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
    x = spm_select('FPlist',pwd,['^mall.*neg',num2str(thr),'.*',roiname{i},'.*.nii']);
    
    y = load_untouch_nii(x);
    img = y.img;
    index = find(img>0);
    indexn = length(index);
    save(['voxeln_allCOneg01',num2str(thr),'_',roiname{i},'.mat'],'indexn');
    
    
end
