% this script is to temporal filter the BOLD signal. input: denoised.nii.
% output: filterpp3_denoised.nii
%test
clear

spm('defaults','fmri');
%pool=parpool('ComputeNode');
spm('defaults','fmri');
% wkdir = '/g5/kirby/xmiao5/XZhou86';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';%with last slash
%wkdir = '//godzilla.kennedykrieger.org/g5/kirby/xmiao5/';
cd(wkdir) 

datasdir=dir('./*RA.ica');
%datadir=dir('./20210729*WW*.ica');%20210729_7T_WW_8_1_Documents.ica
%datadir = [datadir1;datadir2;datadir3;datadir4];

all = {datasdir.name};%cell

prefix='pp3';
%denum = {'36','68','101112','14','234','145'};
SamplePeriod = 2.007;% TR
sampleFreq 	 = 1/2.007;
Band=[0.00,0.03]; %used in paper
%Band=[0.003,0.08];  %resting state 0.08: breathing, heart beat
LowCutoff_HighPass = Band(1);
HighCutoff_LowPass = Band(2);
AAddMeanBack = 'Yes'; %add mean 
%datadir ='/g5/kirby/xmiao5/20200207_olf2';
%%
for n=1:length(all)%[(1:15),(17:length(all))]
    %for r = 1:5
    datadir = [wkdir,all{n}];
    cd(datadir)
    x= spm_select('FPlist',pwd,'^filterpp3.*.nii');
    if isempty(x)
        disp('Start filtering')
        
    

    
    %      if ~exist('CUTNUMBER','var')
    %          CUTNUMBER = 10;
    %      end
    %
       
    %F = spm_select('FPlist',pwd,['^st.*.nii']); //xmiao5 01,02
    F = spm_select('FPlist',pwd,['^den.*','.*.nii']); %input denoised.nii
%     if isempty(F)
%         copyfile('filtered_func_data.nii.gz')
%     end
    
    functmp = load_untouch_nii(F);
    func = functmp.img;
    ss = size(func);%width,length,time
    % Convert into 2D: time series * voxel(flatten)
    AllVolume = reshape(func,[],ss(4))';
    
    %mask selection, added by Xiaowei Song, 20070421
    % fprintf('\n\t Load mask "%s".', AMaskFilename);
    % MaskData=rest_loadmask(nDim1, nDim2, nDim3, AMaskFilename);
    %
    % MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
    
    % MaskDataOneDim=reshape(MaskData,1,[]);
    % MaskIndex = find(MaskDataOneDim);
    % AllVolume=AllVolume(:,MaskIndex);
    
    theMean = mean(AllVolume);
    Data = AllVolume;
    
    
    sampleLength = size(Data,1);
    paddedLength = rest_nextpow2_one35(sampleLength); %2^nextpow2(sampleLength);
    
    
    % Get the frequency index
    if (LowCutoff_HighPass >= sampleFreq/2) % All high stop
        idxLowCutoff_HighPass = paddedLength/2 + 1;
    else % high pass, such as freq > 0.01 Hz
        idxLowCutoff_HighPass = ceil(LowCutoff_HighPass * paddedLength * SamplePeriod + 1);
    end
    
    if (HighCutoff_LowPass>=sampleFreq/2)||(HighCutoff_LowPass==0) % All low pass
        idxHighCutoff_LowPass = paddedLength/2 + 1;
    else % Low pass, such as freq < 0.08 Hz
        idxHighCutoff_LowPass = fix(HighCutoff_LowPass * paddedLength * SamplePeriod + 1);
    end
    
    FrequencyMask = zeros(paddedLength,1);
    FrequencyMask(idxLowCutoff_HighPass:idxHighCutoff_LowPass,1) = 1;
    FrequencyMask(paddedLength-idxLowCutoff_HighPass+2:-1:paddedLength-idxHighCutoff_LowPass+2,1) = 1;
    
    FrequencySetZero_Index = find(FrequencyMask==0);
    
    %Remove the mean before zero padding; average by channel
    demean_Data = Data - repmat(theMean,size(Data,1),1);
    
    zeropad_Data = [demean_Data;zeros(paddedLength -sampleLength,size(Data,2))]; %padded with zero
    
    fft_Data = fft(zeropad_Data);
    
    fft_Data(FrequencySetZero_Index,:) = 0;
    
    Data_Filtered = ifft(fft_Data);
    
    Data_Filtered = Data_Filtered(1:sampleLength,:);
    
    % Add the mean back after filter.
    
    AllVolume = Data_Filtered + repmat(theMean,[ss(4),1]);
    
    
    % AllVolumeBrain = single(zeros(nDimTimePoints, nDim1*nDim2*nDim3));
    % AllVolumeBrain(:,MaskIndex) = AllVolume;
    
    AllVolumeBrain=reshape(AllVolume',[ss(1), ss(2), ss(3), ss(4)]);
    
    
    %Save all images to disk
    
    functmp.img=AllVolumeBrain;
    %save_untouch_nii(functmp,['filter',prefix,'_strdenoised',denum{n},'.nii']);
    save_name = ['filter',prefix,'_denoised','.nii'];
    save_untouch_nii(functmp,save_name);
    disp(['===<',save_name,'>','===saved!'])
    
    clear AllVolume AllVolumeBrain zeropad_Data fft_Data Data Data_Filtered func functmp img img1 theMean
    end
end
cd (wkdir)
% %% show filter result
% % demean:demean_Data, Data_Filtered
% % mean: Data, AllVolume
% 
% % find non zero channel
% for idx = 1:2150400
%     if any(demean_Data(:,idx))
%         iiddxx = idx
%         break
%     end
% end
% 
% figure()
% idx = 71;
% plot(demean_Data(:,idx));
% hold on
% plot(Data_Filtered(:,idx));
% legend('raw data','filtered')
% title('idx = 71')
% xlabel('time')