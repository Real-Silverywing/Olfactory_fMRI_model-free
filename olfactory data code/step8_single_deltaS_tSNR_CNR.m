%calculate the tSNR, deltaS/S, CNR, signal change time course of each common ROI, positive or negative
%voxels.
%input: wfilterpp3_denoised.nii
%       mposi/neg{roi name}.nii
%output:deltaS_tSNR_CNR_allCOposi/neg*.mat 
%       deltatimecourse_allCOposi/neg*.mat

clear
% ROIdir = '/g5/kirby/xmiao5/XZhou86/ROI';

% wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
cd(wkdir)
datasdir=dir('./*RA.ica');
ROIdir = [wkdir,'ROI\'];
% datasdir=dir('**/2*.ica');
%datasdir=dir('./20210729*WW*.ica');
%
actdir = '\posi_neg_ROI';
all = {datasdir.name};
des = {datasdir.folder};
roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Insula_AAL','OFC_AAL','Amy_exPiri_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
cc = [61:120,151:210,241:300]-24;
sst = [31:60,121:150,211:240]-24;
thr = 5;
prefix = 'wfilterpp3';
pn ={'posi','neg'};
%%

for pnx = 1:2   %loop for posi or neg
    for n=[1:length(all)] %loop for subjects
        datadir = [wkdir,all{n}];
        cd(datadir)
        if ~exist('deltatime','dir')
            mkdir('deltatime')
        end
        for r = 1:length(roiname) %loop for ROIs
            %P =
            %spm_select('FPlist',rootdir,['^mallCO',pn{pnx},thr,'_.*',roiname{r},'.*.nii']);%result of step 7
            %P = spm_select('FPlist',rootdir,['^posineg_sdelta_',pn{pnx},thr,'_.*',roiname{r},'.*.nii']);
            P = spm_select('FPlist',actdir,['^m',pn{pnx},'_',roiname{r},'.nii']);
            %posineg_sdelta_hmap01_wfilterpp3Amy_exPiri_AAL
            P_t = load_untouch_nii(P);
            P_i = P_t.img;
            
            index = find(P_i>0);%posi or neg map
%             countposi = length(index);
%             save(['voxelcount_allCOposi_',roiname{r},'.mat'],'countposi');
            
            x = spm_select('FPlist',pwd,['^',prefix,'_denoised.nii']);
            
            
            img = x;%spm_select('FPlist',pwd,['^',prefix,'.*.nii']);
            
            imgt = load_untouch_nii(img);
            img = imgt.img;
            sss = size(img);
            img_v = reshape(img,[],sss(4));
            img_actroi = img_v(index,:);
            
            b1 = mean(img_actroi,1);
            mean_tSNR = mean(b1(cc));
            std_tSNR = std(b1(cc));
            tSNR = mean_tSNR./std_tSNR;
            
            b = mean(img_actroi,1);
            c1_act = mean(b([61:120]-24));
            s1_act = mean(b([31:60]-24));
            deltaS1act = (s1_act-c1_act)/c1_act;
            CNR1act = tSNR.*deltaS1act;
            deltaS1actp = deltaS1act*100;
            
            c2_act = mean(b([151:210]-24));
            s2_act = mean(b([121:150]-24));
            deltaS2act = (s2_act-c2_act)/c2_act;
            CNR2act = tSNR.*deltaS2act;
            deltaS2actp = deltaS2act*100;
            
            c3_act = mean(b([241:300]-24));
            s3_act = mean(b([211:240]-24));
            deltaS3act = (s3_act-c3_act)/c3_act;
            CNR3act = tSNR.*deltaS3act;
            deltaS3actp = deltaS3act*100;
            
            mean_controlall_act = mean(b(cc));
            mean_stiall_act = mean(b(sst));
            delta_all = mean_stiall_act-mean_controlall_act;
            deltaSallact = delta_all*100/mean_controlall_act;
            CNRallact = tSNR.*deltaSallact;
            
            deltab_act = (b-mean_controlall_act)/mean_controlall_act;
            
            save([des{n},'/',all{n},'/deltatime','/deltatimecourse_',pn{pnx},'_',prefix,roiname{r},'.mat'],'deltab_act');
            save([des{n},'/',all{n},'/deltatime','/deltaS_tSNR_CNR_',pn{pnx},'_',prefix,roiname{r},'.mat'],'deltaS1actp',...
                'CNR1act','tSNR','deltaS2actp','deltaS3actp','CNR2act','CNR3act','deltaSallact','CNRallact');
                        
        end
        
    end
end