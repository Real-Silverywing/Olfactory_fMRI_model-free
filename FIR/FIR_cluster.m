clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
ROIdir = fullfile(wkdir,'My_ROI');
roiname = {'OB', 'OFC', 'olf'};
FIR_path =fullfile(wkdir, './FIR_cluster/');  
cd (FIR_path)
load HRF_estimation.mat
%% select subject
n=3;
k=5;


estimate_path = './FIR_cluster/';
save_path = './FIR_cluster/';

estimate = {dir([wkdir,estimate_path,'*7T*']).name};
savedir = fullfile(wkdir, save_path, estimate{n});

    
clustered_HRFs = cell(k,length(roiname));
cluster_maps = cell(1,length(roiname));
%% ROI

for r = 1:length(roiname) %roi
    

    mask_block_fit = hrf{n,r};
    data = mask_block_fit';% for cluster, X:m*n, m(oberservations) is number of voxel , n(variables) is timepoint
    
    % ROI
    
    roi_file_name = spm_select('FPlist',ROIdir,['^',estimate{n}(end-1:end),'_',roiname{r},'.nii']);
    roifile = load_untouch_nii(roi_file_name);
    roi = roifile.img;
    roi_flat = reshape(roi,[],1);
    roi_flat_voxel_index = find(roi_flat == 1);
    % cluster

    data_cluster = data - mean(data,2);
    [removed_data_cluster, keep_idx] = small_std_helper(data_cluster);
    [idx,C] = kmeans(removed_data_cluster,k,'Distance','correlation');
%     [idx,C] = kmeans(data_cluster,k);
    
    cluster_map = zeros(size(roi_flat));
    roi_flat_voxel_index = roi_flat_voxel_index(keep_idx);
    cluster_map(roi_flat_voxel_index) = idx;
    cluster_maps{r} = reshape(cluster_map,size(roi));
    save_cluster_map(cluster_maps{r},savedir,k,roiname{r});

    for i = 1:k
        clustered_HRFs{i,r} = data(idx == i,:);
    end


    figure
    for i = 1:k
        curve = mean(clustered_HRFs{i,r});
        curve = 2*(curve - min(curve,[],2))./(max(curve,[],2)-min(curve,[],2)) - 1;
        subplot(k,1,i)

        plot_paradigm_block()
        plot(curve)
        xlabel(['k=',num2str(i),' voxel num=',num2str(size(clustered_HRFs{i,r},1))])
        if i==1
            title([estimate{n},': ',roiname{r}],'Interpreter','none')
        end
    end
end
function [] = save_cluster_map(cluster_map,path,k,roi)
p = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use\cluster\';
label_name = spm_select('FPlist',p,'^label.nii');
file = load_untouch_nii(label_name);
file.img = cluster_map;
save_fakeuntouch_nii(file,[path,'\',roi,'_cluster_map',num2str(k),'.nii'])
% niftiwrite(cluster_map,[path,'\cluster_map',num2str(k),'.nii']);
end
function [] = plot_paradigm_block()
%PLOT_PARADIAM Summary of this function goes here
%   Detailed explanation goes here
% figure()
set(gcf,'position',[500,400,1200,400])
rectangle('Position',[0, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)

% rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
% rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',

ylim([-1 1])
yticks([-1,0,1])
%yticklabels({'-1','0','1','2'}) %posi
yticklabels({'-1','0','1'})  %neg


hold on;
line([1,276],[0,0],'LineWidth',1.5,'Color','black')
line([0,29],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
% line([97,126],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
% line([187,216],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
xlim([0 90]);
end
