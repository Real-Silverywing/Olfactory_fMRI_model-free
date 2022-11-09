clc
clear

root = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
cd 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use'
estimate_path = '1st level/';
estimate = {dir('./1st level/*7T*').name};

thres = 3.12;
for n = 2:2
    tfiledir = fullfile(root, estimate_path,estimate{n});
    tfile_name = spm_select('FPlist',tfiledir,'spmT_0001.nii');
    tfile = load_untouch_nii(tfile_name);
    tmap3d = tfile.img;
    tmap = reshape(tmap3d,1,[]);
    
    strucdir = fullfile(root, estimate{n});
    strucfile_name = spm_select('FPlist',strucdir,'^r.*.nii');
    strucfile = load_untouch_nii(strucfile_name);
    struc = strucfile.img;
    
    funcdir = fullfile(root, estimate{n});
    funcfile_name = spm_select('FPlist',funcdir,'^2.*.8.*.nii');
%     % normalized
%     funcfile_name = spm_select('FPlist',funcdir,'^w.*.8.*.nii');
    funcfile = load_untouch_nii(funcfile_name);
    func = funcfile.img;
    func = func(:,:,:,25:300); % remove first 24 frames
    ss = size(func);%width,length,time
    % Convert into 2D: time series * voxel(flatten)
    func_flat = reshape(func,[],ss(4))';
    
    act = find(tmap>thres);
    figure
    plot(func_flat(:,act));
    title([estimate{n},'    t>',num2str(thres)], 'Interpreter', 'none')
    
    
end

%%
thres = -4;
act = find(tmap<thres);
figure
% plot(func_flat(:,act))
t = 1:276;

figure

ylim([-1 1.2])
yticks([-1,0,1])
% yticklabels({'-2','0','2','4'}) %posi
yticklabels({'-1','0','1'}) %neg
rectangle('Position',[31-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)

rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',
hold on
data = func_flat(:,act)';
s=shadedErrorBar(t,mean(data,1),std(double(data)));

%%
% y=randn(30,80); 
% x=1:size(y,2);
% figure()
% s=shadedErrorBar(t,mean(data,1),std(double(data)));
%%
figure,imshow(tmap3d(60:100,1:30,10))
% only OB
% funcs = func(60:100,1:30,10:40,25:300);
%%
thres = -1.78;
funcs = func(60:100,1:30,10:40,:);
sss = size(funcs);%width,length,time
% Convert into 2D: time series * voxel(flatten)
funcs_flat = reshape(funcs,[],sss(4))';
ob3d = tmap3d(60:100,1:30,10:40);
% ob_flat = reshape(ob3d,1,[]);
ob_act = find(ob3d<thres);
figure
[row,col,page] = ind2sub(sss(1:3),ob_act);
plo = zeros(276,length(row));
for i=1:length(row)
    
    plo(:,i) = funcs(row(i),col(i),page(i),:);
end
figure
plot(plo)