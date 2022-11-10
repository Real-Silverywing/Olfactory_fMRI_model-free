%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To improve the effiency, only the timecourse of the voxel which is within ROI is selected 
% saved as masked_timecourse.mat f
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
ROIdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\ROI';
roiname1 = {'OFC_AAL','MNI_OB_manual2','Figure_1B_MNI152_ROI_1mm'};
roinameJG = {'JG_OFC_AAL','JG_MNI_OB_manual2','JG_Figure_1B_MNI152_ROI_1mm'};
roiname2 = {'Insula_AAL','Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL'...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
roiname3 = {'Amy_exPiri_AAL'};
roiname = roinameJG;
% roiname = [roiname1,roiname2,roiname3];

cd (wkdir)

%% select subject
n=1;


save_path = './FIR_cluster_norm/';


subject = {dir('*7T*').name};
savedir = fullfile(wkdir, save_path, subject{n});

if ~exist(savedir,'dir')
    mkdir(savedir);
end


funcdir = fullfile(wkdir, subject{n});
funcfile_name = spm_select('FPlist',funcdir,'^wfilter.*.nii');
funcfile = load_untouch_nii(funcfile_name);
func = funcfile.img;
ss = size(func);%width,length,time
func_flat = reshape(func,[],ss(4))';

%% ROI

for r = 1:length(roiname) %roi
    roi_file_name = spm_select('FPlist',ROIdir,['^',roiname{r},'.nii']);
    roifile = load_untouch_nii(roi_file_name);
    roi = roifile.img;
    roi_flat = reshape(roi,[],1)';
    roi_flat_voxel_index = find(roi_flat ~= 0);
    namestr = [char(roiname(r)) '=func_flat(:,roi_flat_voxel_index);'];
    eval(namestr);
    % mask ROI 
    
    
end
cd (savedir)
save('masked_timecourse.mat', 'JG_OFC_AAL','JG_MNI_OB_manual2','JG_Figure_1B_MNI152_ROI_1mm')

