clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
ROIdir = fullfile(wkdir,'My_ROI','reverse');
roiname = {'iwFigure_1B_MNI152_ROI_1mm',  'iwMNI_OB_manual2'};


root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'
% estimate_path = '1st level/';
% estimate = {dir('./1st level/*7T*').name};
estimate_path = '1st_smooth/';
estimate = {dir('./1st_smooth/*7T*').name};



n=1;
% thres = 3.12;% p =0.001
thres = 2.5;


funcdir = fullfile(root, estimate{n});
% funcfile_name = spm_select('FPlist',funcdir,'^w.*.8.*.nii');% normalized
funcfile_name = spm_select('FPlist',funcdir,'^s.*.8.*.nii');
funcfile = load_untouch_nii(funcfile_name);
func = funcfile.img;
func = func(:,:,:,25:300); % remove first 24 frames
ss = size(func);%width,length,time
func_flat = reshape(func,[],ss(4))';
for r = 1:1%length(roiname) %roi

    
    mtfiledir = fullfile(root, estimate_path,estimate{n},'rev_mask');
    mtfile_name = spm_select('FPlist',mtfiledir,['ROI_tmap01_',roiname{r},'.nii']);
    mtfile = load_untouch_nii(mtfile_name);
    mtmap3d = mtfile.img;
    mtmap = reshape(mtmap3d,1,[]);

    act = find(mtmap>thres);
    plot_paradigm()
    hold on
    t = 1:276;
    data = double(func_flat(:,act)');
%     mdata = normalize(data','range',[-1 1]);
%     mdata = data - mean(data,2);
    mdata = 2*(data - min(data,[],2))./(max(data,[],2)-min(data,[],2)) - 1;
    if length(act) > 1
        s=shadedErrorBar(t,mean(mdata,1),std(double(mdata)),'lineProps','r');
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=',num2str(size(mdata,1))]}, 'Interpreter', 'none');
    elseif length(act) == 1
        plot(mdata)
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=',num2str(size(mdata,1))]}, 'Interpreter', 'none');
    else
        title({[estimate{n},':  ',roiname{r}];['t>',num2str(thres),'  voxel=0']}, 'Interpreter', 'none');
         
        
    end
end

function [] = plot_paradigm()
%PLOT_PARADIAM Summary of this function goes here
%   Detailed explanation goes here
figure()
set(gcf,'position',[500,400,1200,400])
rectangle('Position',[31-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)

rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',

ylim([-1 1])
yticks([-1,0,1])
%yticklabels({'-1','0','1','2'}) %posi
yticklabels({'-1','0','1'})  %neg


hold on;
line([1,276],[0,0],'LineWidth',1.5,'Color','black')
line([7,36],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
line([97,126],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
line([187,216],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
end     


