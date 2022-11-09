%this script is for the calculation of the positive and negative
%activations in the olf ROIs.
%input: wfilterpp3_denoised.nii
%       hmap*wfilterpp3*.nii
%output: deltamap_wfilterpp3.nii, (the deltaS/S map of the whole brain)
%        posineg_sdelta_hmap01*.nii, (the mask of posi/neg voxels in each olf
%            ROI. the positively activated voxels are 1,
%            the negatively activated voxels are -1)
%        sdeltamap_wfilterpp3.nii, middle result


clear
% wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
cd(wkdir) 
datasdir=dir('./*RA.ica');
% datasdir=dir('./*.ica');
%datasdir=dir('./20210729*WW*.ica');

templetedir = wkdir;
all = {datasdir.name};

roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Insula_AAL','OFC_AAL','Amy_exPiri_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};

prefix = 'wfilterpp3';
cc = [61:120,151:210,241:300]-24;
sst = [31:60,121:150,211:240]-24;
for n=[1:length(all)]
    cd([wkdir,all{n}])
    %load wfilterpp3_denoised.nii
    P = spm_select('FPlist',pwd,[prefix,'_denoised*']);
%     check = size(P);
%     if check(1)~= 1
%         error('Error. \nInput must be a char, not a %s.',[pwd,prefix,'_denoised*'])
%     end
    P_t = load_untouch_nii(P);
    P_i = P_t.img;
    sss = size(P_i);
    
    %load hmap_wfilterpp3_01.nii
    hmapfile = spm_select('FPlist',pwd,['hmap_',prefix,'_01.mat']);
%     check = size(hmapfile);
%     if check(1)~= 1
%         error('Error.hmap ')
%     end
    load(hmapfile);
    roi_i = hmap;
    %roi_i(roi_i>0)=1;
    %roi_i(roi_i<=0) =0;

    roi_ir = reshape(roi_i,[],1);
    % find where h=1, which voxel is activated
    index = find(roi_ir ==1);
    P_ir = reshape(P_i,[],sss(4));
    ss= size(P_ir);

    control1 = P_ir(:,cc);%[61:120]

    sti1_half = P_ir(:,sst);%[31:60]


    t=1:ss(2);
    deltaSmap = zeros(ss(1),1);
    for i = 1:length(index)
        P1 = P_ir(index(i),:);
        b=P1;
        %deltaS/S
        mean_controlall_posi = mean(b(cc));
        mean_stiall_posi = mean(b(sst));
        delta_all = mean_stiall_posi - mean_controlall_posi;
        deltaSall = delta_all / mean_controlall_posi;
        %CNRall = tSNR.*deltaSall;
        deltaStmp = deltaSall;
        deltaSmap(index(i)) = deltaStmp*100;
    end
    % to save generated deltaSmap, using similiar file to create a templete
    % and replace img obj with deltaSmap
    deltaSm = reshape(deltaSmap,sss(1),sss(2),sss(3));
    templete_file = spm_select('FPlist',templetedir,'^templete.*.nii');
    templete = load_untouch_nii(templete_file);
    templete.img =deltaSm;

    save_fakeuntouch_nii(templete,['deltamap_',prefix,'.nii'])
    %save_untouch_nii(tmp,['deltamap_',prefix,'.nii'])
    Q = spm_select('FPlist',pwd,['^deltamap_.*',prefix,'.*.nii']);
%     check = size(Q);
%     if check(1)~= 1
%         error('Error.Q ')
%     end
    matlabbatch{1}.spm.spatial.smooth.data = cellstr(Q);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [2 2 2];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    spm_jobman('run',matlabbatch); % save sdeltamap_wfilterpp3.nii (smoothed? deltamap_wfilterpp3)


    %P = spm_select('FPlist',pwd,['^sdelta.*',prefix,'.*.nii']);
    P = spm_select('FPlist',pwd,['sdeltamap_wfilterpp3.nii']);
%     check = size(P);
%     if check(1)~= 1
%         error('Error.P ')
%     end
    P_t = load_untouch_nii(P);
    P_i = P_t.img;
    sss = size(P_i);

    Pv = reshape(P_i,[],1);
    ss = size(Pv);

%smoothed deltamap-->  1,0,-1
    map = Pv;
    map(map>0) = 1;
    map(map<0) = -1;
%     map=zeros(ss(1),1);
%     for i=1:ss(1)
%         if Pv(i) > 0
%             map(i) = 1;
%         elseif Pv(i)<0
% 
%             map(i)= -1;
%         end
%     end

    
    
    
    
    
    map_r = reshape(map,sss(1),sss(2),sss(3));
    for r = 1:length(roiname)
        %hmaproi = spm_select('FPlist',[wkdir,all{n},'/KS'],['^ROI_hmap01.*wfilterpp3.*',roiname{r},'.*.nii']);%['^ROI_hmap.*',prefix,'.*',roiname{r},'.*.nii']
        hmaproi = spm_select('FPlist',[wkdir,all{n},'/KS'],['^ROI_hmap01.*wfilterpp3',roiname{r},'.*.nii']);
%         check = size(hmaproi);
%         if check(1)~= 1
%             %error('Error.hmaproi ')
%             disp('multiple roi')
%             hmaproi = spm_select('FPlist',[wkdir,all{n},'/KS'],['^ROI_hmap01.*wfilterpp3',roiname{r},'.nii']);;
%         end
        roi_t = load_untouch_nii(hmaproi);
        roi_i = single(roi_t.img);
        roi_i(roi_i>0) = 1;
        roi_i(roi_i<=0) = 0;

        % roi as mask, multiply with deltamap
        map_roi=map_r.*roi_i;

        roi_t.img = map_roi;
        save_untouch_nii(roi_t,['posineg_sdelta_hmap01_',prefix,roiname{r},'.nii']);

    end
end
        
     
