clc
clear
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
ROIdir = fullfile(wkdir,'My_ROI');
roiname = {'OB', 'OFC', 'olf'};

root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'
% estimate_path = '1st level/';
% estimate = {dir('./1st level/*7T*').name};

n=1;



estimate_path = '1st level/';
estimate = {dir(['./',estimate_path,'*7T*']).name};
funcdir = fullfile(root, estimate{n});
% funcfile_name = spm_select('FPlist',funcdir,'^w.*.8.*.nii');% normalized
funcfile_name = spm_select('FPlist',funcdir,'^filter.*.nii');
funcfile = load_untouch_nii(funcfile_name);
func = funcfile.img;
ss = size(func);%width,length,time
func_flat = reshape(func,[],ss(4))';
%% select subject and get timecourse
% thres = 3.12;% p =0.001

abs_thres = 1;
sign = -1;
thres = abs_thres * sign;

time_course = {};
for r = 1:length(roiname) %roi

    
    mtfiledir = fullfile(root, estimate_path,estimate{n},'mask');
    mtfile_name = spm_select('FPlist',mtfiledir,['ROI_tmap01_',roiname{r},'.nii']);
    mtfile = load_untouch_nii(mtfile_name);
    mtmap3d = mtfile.img;
    mtmap = reshape(mtmap3d,1,[]);
    ploting = 0;
    time_course{r} = threshold_data(estimate, roiname, n, r, abs_thres, sign, mtmap, func_flat, ploting);


    
         
        
    
end
%% k-menas

k = 10;
clusters = cell(length(roiname),k);
for r = 1:length(roiname) %roi
    
    if size(time_course{r},1) >1

        [idx,C] = kmeans(time_course{r},k,'Distance','correlation');


        for i = 1:k
            clusters{r,i} = time_course{r}(idx == i,:);
        end
    end
    
    


    
         
        
    
end 
%%
roi_index = 3;
figure
for i = 1:k
    curve = mean(clusters{roi_index,i});
    subplot(k,1,i)
    plot_paradigm()
    plot(curve)
    
    
end

%%
function [] = plot_paradigm()
%PLOT_PARADIAM Summary of this function goes here
%   Detailed explanation goes here
% figure()
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





function [mdata] = threshold_data(estimate, roiname, n, r, abs_thres, sign, mtmap, func_flat, ploting)
    thres = abs_thres * sign;
    if sign == -1
        act = find(mtmap<thres);
        t = 1:276;
        data = double(func_flat(:,act)');
    %     mdata = normalize(data','range',[-1 1]);
    %     mdata = data - mean(data,2);
        mdata = 2*(data - min(data,[],2))./(max(data,[],2)-min(data,[],2)) - 1;
        if ploting == 1
            plot_paradigm()
            hold on
            if length(act) > 1
                s=shadedErrorBar(t,mean(mdata,1),std(double(mdata)),'lineProps','r');
                title({[estimate{n},':  ',roiname{r}];['t<',num2str(thres),'  voxel=',num2str(size(mdata,1))]}, 'Interpreter', 'none');
            elseif length(act) == 1
                plot(mdata)
                title({[estimate{n},':  ',roiname{r}];['t<',num2str(thres),'  voxel=',num2str(size(mdata,1))]}, 'Interpreter', 'none');
            else
                title({[estimate{n},':  ',roiname{r}];['t<',num2str(thres),'  voxel=0']}, 'Interpreter', 'none');
            end
        end
    else
        act = find(mtmap>thres);

        t = 1:276;
        data = double(func_flat(:,act)');
    %     mdata = normalize(data','range',[-1 1]);
    %     mdata = data - mean(data,2);
        mdata = 2*(data - min(data,[],2))./(max(data,[],2)-min(data,[],2)) - 1;
        if ploting == 1
            plot_paradigm()
            hold on
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
    end
end     