clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
ROIdir = fullfile(wkdir,'My_ROI');
roiname = {'OB', 'OFC', 'olf'};
root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'

%% select subject
n=2;


estimate_path = './FIR_cluster/';
save_path = './FIR_cluster/';

estimate = {dir([estimate_path,'*7T*']).name};
savedir = fullfile(root, save_path, estimate{n});

funcdir = fullfile(root, estimate{n});
funcfile_name = spm_select('FPlist',funcdir,'^filter.*.nii');
funcfile = load_untouch_nii(funcfile_name);
func = funcfile.img;
ss = size(func);%width,length,time
func_flat = reshape(func,[],ss(4))';

%% ROI

for r = 1:length(roiname) %roi
    roi_file_name = spm_select('FPlist',ROIdir,['^',estimate{n}(end-1:end),'_',roiname{r},'.nii']);
    roifile = load_untouch_nii(roi_file_name);
    roi = roifile.img;
    roi_flat = reshape(roi,[],1)';
    roi_flat_voxel_index = find(roi_flat == 1);
    namestr = [char(roiname(r)) '=func_flat(:,roi_flat_voxel_index);'];
    eval(namestr);
    % mask ROI 
    
    
end
cd (savedir)
save('masked_timecourse.mat', 'OB', 'OFC', 'olf')

