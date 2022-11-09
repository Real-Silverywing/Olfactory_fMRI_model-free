%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate HRF from timecourse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear

wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';
FIR_path =fullfile(wkdir, './FIR_cluster/');  
roiname = {'OB', 'OFC', 'olf'};
estimate = {dir([FIR_path,'*7T*']).name};
datasdir=dir('*7T*');
all = {datasdir.name};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Settings
% 

TR = 2;
tc_length = 90;%num of time point withiun timecourse (scan
%T = round(30/TR);
T = 180;%???
t = 1:TR:T;                        % samples at which to get Logit HRF Estimate
FWHM = 4;                       % FWHM for residual scan
pval = 0.01;
df = 180;
alpha = 0.001;
mode = 0;   % 0 - FIR 
            % 1 - smooth FIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = [1:30]; 

Run = zeros(tc_length,1);
for i=1:length(R), Run(R(i):R(i)) = 1; end
Runc{1} = Run;
hrf = cell(3,3);
fit = cell(3,3);
for n=1:3%length(all)
    datadir = fullfile(FIR_path, estimate{n});
    cd (datadir)
    load masked_timecourse.mat
    for r = 1:length(roiname)

        eval(['func_flat = ' char(roiname(r)) ';']);
        block_func_flat = func_flat(7:96,:); % only fist block scan=7:96
        block_h = zeros(tc_length,size(block_func_flat,2));
        block_fit = zeros(tc_length,size(block_func_flat,2));
        %% FIR fit 
        for i = progress(1:size(block_func_flat,2))
            tc = block_func_flat(:,i);
    %         tc = block_func_flat(:,42342);
            % tc = (tc- mean(tc))/std(tc)
            [h1, fit1, e1, param] = Fit_sFIR(tc,TR,Runc,T,mode);
            block_h(:,i) = h1;
            block_fit(:,i) = fit1;
        end
        hrf{n,r} = block_h;
        fit{n,r} = block_fit;
    end
end
cd (FIR_path)
save HRF_estimation.mat hrf fit