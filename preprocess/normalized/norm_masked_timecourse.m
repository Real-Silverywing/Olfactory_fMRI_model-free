clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
ROIdir = [wkdir,'ROI\'];
roiname1 = {'Insula_AAL','OFC_AAL','MNI_OB_manual2'};%,'ob_new'};%'Olfactory_AAL',
roiname2 = {'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL'...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
roiname3 = {'Amy_exPiri_AAL','Figure_1B_MNI152_ROI_1mm'};% 'Figure_1B_MNI152_ROI_1mm'==primary olf cortex
roiname = [roiname1,roiname2,roiname3];

root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'
estimate_path = '1st_norm/';
estimate = {dir('./1st_norm/*7T*').name};



n=1;
% thres = 3.12;% p =0.001
thres = 2;


funcdir = fullfile(root, estimate{n});
funcfile_name = spm_select('FPlist',funcdir,'^w.*.8.*.nii');
funcfile = load_untouch_nii(funcfile_name);
func = funcfile.img;
func = func(:,:,:,25:300); % remove first 24 frames
ss = size(func);%width,length,time
func_flat = reshape(func,[],ss(4))';
for r = 1:length(roiname) %roi

    
    mtfiledir = fullfile(root, estimate_path,estimate{n},'mask');
    mtfile_name = spm_select('FPlist',mtfiledir,['ROI_tmap01_',roiname{r},'.nii']);
    mtfile = load_untouch_nii(mtfile_name);
    mtmap3d = mtfile.img;
    mtmap = reshape(mtmap3d,1,[]);

    act = find(mtmap>thres);
    figure
    t = 1:276;
    data = func_flat(:,act)';
    if length(act) > 1
        s=shadedErrorBar(t,mean(data,1),std(double(data)));
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=',num2str(size(data,1))]}, 'Interpreter', 'none');
    elseif length(act) == 1
        plot(data)
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=',num2str(size(data,1))]}, 'Interpreter', 'none');
    else
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=0']}, 'Interpreter', 'none');
         
        
    end
end



