% this script is to temporal filter the BOLD signal. input: ^<NAME>.nii.
% output: fr<NAME>.nii
%test
clc
clear

spm('defaults','fmri');
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\Model Free Use';%with last slash

cd(wkdir) 

datasdir=dir('*7T*');%^.*?(?<!ica)
ica = contains({datasdir.name},'.ica');
all = cell(1,length(find(ica == 0)));
n = 1;
for i = 1: length(datasdir)
    if ~ica(i)
        all{n} = datasdir(i).name;
        n=n+1;
    end
end



prefix='pp3';
%denum = {'36','68','101112','14','234','145'};
SamplePeriod = 2.007;% TR
sampleFreq 	 = 1/2.007;
Band=[0.00,0.03]; %used in paper
%Band=[0.003,0.08];  %resting state 0.08: breathing, heart beat
LowCutoff_HighPass = Band(1);
HighCutoff_LowPass = Band(2);
AAddMeanBack = 'Yes'; %add mean 
%%
for n=1:length(all)%[(1:15),(17:length(all))]
    %for r = 1:5
    datadir = fullfile(wkdir,all{n});
    cd(datadir)
    x= spm_select('FPlist',pwd,'^f.*.nii'); % check generated file
    if isempty(x)
        disp('Start filtering')
        
    

    
    %      if ~exist('CUTNUMBER','var')
    %          CUTNUMBER = 10;
    %      end
    %
       

    F = spm_select('FPlist',pwd,['^2.*8_1.*.nii']); %input denoised.nii
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
    Data = double(AllVolume);
    
    
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
    save_name = ['f',all{n},'_8_1.nii'];
    save_untouch_nii(functmp,save_name);
    disp(['===<',save_name,'>','===saved!'])
    
    clear AllVolume AllVolumeBrain zeropad_Data fft_Data Data Data_Filtered func functmp img img1 theMean
    end
end
cd (wkdir)
