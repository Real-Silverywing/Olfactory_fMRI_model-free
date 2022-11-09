%calculate the tSNR, deltaS/S, CNR, signal change time course of each common ROI, positive or negative
%voxels.
%input: wfilterpp3_denoise.nii
%       mallCOposi/neg*.nii(unique=0,32767)
%output:deltaS_tSNR_CNR_allCOposi/neg*.mat 
%       deltatimecourse_allCOposi/neg*.mat

clear
rootdir = '/g5/kirby/xmiao5/XZhou86/ROI';
wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path

cd(wkdir)
datadir=dir('**/2*.ica');
%datadir=dir('./20210729*WW*.ica');
%
all = {datadir.name};
des = {datadir.folder};
roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Insula_AAL','OFC_AAL','Amy_exPiri_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
cc = [61:120,151:210,241:300]-24;
sst = [31:60,121:150,211:240]-24;
th = {'5','5'};
prefix = 'wfilterpp3';
pn ={'posi','neg'};
%%

for pnx = 1:2   %loop for posi or neg
    for n=[1:length(all)] %loop for subjects
        for r = 1:length(roiname) %loop for ROIs
            if r<4
                thr = th{1};
            else
                thr = th{2};
            end
            %P =
            %spm_select('FPlist',rootdir,['^mallCO',pn{pnx},thr,'_.*',roiname{r},'.*.nii']);%result of step 7
            %P = spm_select('FPlist',rootdir,['^posineg_sdelta_',pn{pnx},thr,'_.*',roiname{r},'.*.nii']);
            P = spm_select('FPlist',rootdir,['^mallCO',pn{pnx},thr,'_.*',roiname{r},'.*.nii']);
            %posineg_sdelta_hmap01_wfilterpp3Amy_exPiri_AAL
            P_t = load_untouch_nii(P);
            P_i = P_t.img;
            
            posiindex = find(P_i>0);
            countposi = length(posiindex);
            %      save(['voxelcount_allCOposi_',roiname{r},'.mat'],'countposi');
            
            x = spm_select('FPlist',[des{n},'/',all{n}],['^',prefix,'_denoised.nii']);
            
            
            img = x;%spm_select('FPlist',pwd,['^',prefix,'.*.nii']);
            
            imgt = load_untouch_nii(img);
            img = imgt.img;
            sss = size(img);
            img_v = reshape(img,[],sss(4));
            allindex = find(P_i>0);
            % allindex = find(P_i==1|P_i==-1);
            imgposiroi = img_v(posiindex,:);
            % imgnegroi  = img_v(negindex,:);
            imgallroi = img_v(allindex,:);
            b1 = mean(imgallroi,1);
            mean_tSNR = mean(b1(cc));
            std_tSNR = std(b1(cc));
            tSNR = mean_tSNR./std_tSNR;
            
            b = mean(imgposiroi,1);
            c1_posi = mean(b([61:120]-24));
            s1_posi = mean(b([31:60]-24));
            deltaS1posi = (s1_posi-c1_posi)/c1_posi;
            CNR1posi = tSNR.*deltaS1posi;
            deltaS1posip = deltaS1posi*100;
            
            c2_posi = mean(b([151:210]-24));
            s2_posi = mean(b([121:150]-24));
            deltaS2posi = (s2_posi-c2_posi)/c2_posi;
            CNR2posi = tSNR.*deltaS2posi;
            deltaS2posip = deltaS2posi*100;
            
            c3_posi = mean(b([241:300]-24));
            s3_posi = mean(b([211:240]-24));
            deltaS3posi = (s3_posi-c3_posi)/c3_posi;
            CNR3posi = tSNR.*deltaS3posi;
            deltaS3posip = deltaS3posi*100;
            
            mean_controlall_posi = mean(b(cc));
            mean_stiall_posi = mean(b(sst));
            delta_all = mean_stiall_posi-mean_controlall_posi;
            deltaSallposi = delta_all*100/mean_controlall_posi;
            CNRallposi = tSNR.*deltaSallposi;
            
            deltabposi = (b-mean_controlall_posi)/mean_controlall_posi;
            
            save([des{n},'/',all{n},'/deltatimecourse_allCO',pn{pnx},'_group',prefix,roiname{r},'.mat'],'deltabposi');
            save([des{n},'/',all{n},'/deltaS_tSNR_CNR_allCO',pn{pnx},'_group',prefix,roiname{r},'.mat'],'deltaS1posip',...
                'CNR1posi','tSNR','deltaS2posip','deltaS3posip','CNR2posi','CNR3posi','deltaSallposi','CNRallposi');
                        
        end
        
    end
end