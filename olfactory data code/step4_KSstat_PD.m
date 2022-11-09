% KS statistics. generate the map of significant voxels.
%Input: wfilterpp3_denoised.nii (normalized functional data)
%Output: 'hmap_wfilterpp3_01.nii/.mat' 
%         pmap_wfilterpp3_01.nii/.mat
%         chi2map_wfilterpp3_01.nii/.mat
    
clear
%pool=parpool('ComputeNode');
%spm('defaults','fmri');
% wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
wkdir = 'E:\OneDrive Local\OneDrive - Johns Hopkins\Desktop\Lab\fMRI_data\';
cd(wkdir) 
% datadir = dir('./*.ica');
datasdir=dir('./*RA.ica');
%datadir=dir('./20210729*WW*.ica');

all = {datasdir.name};
prefix='wfilterpp3';

%%
for  n=1:length(all)
    
    datadir = [wkdir,all{n}];
    cd(datadir)
    % check result exist
    e_hmap = spm_select('FPlist',pwd,['hmap_',prefix,'_01.nii']);
    e_pmap = spm_select('FPlist',pwd,['pmap_',prefix,'_01.nii']);
    e_chi2map = spm_select('FPlist',pwd,['chi2map_',prefix,'_01.nii']);
    if ~(isempty(e_hmap) || isempty(e_pmap) || isempty(e_chi2map))
        % P:wfilterpp3_denoised.nii (normalized functional data)
        P = spm_select('FPlist',pwd,['^',prefix,'.*.nii']);
        tmp = load_untouch_nii(P);

        img=tmp.img;

        ss = size(img);


        img_mask = img;
        img_mask_v = reshape(img_mask,[],ss(4));


      %the design of the olfactory task, removed the first 24 time points.
        control = img_mask_v(:,[61:120,151:210,241:300]-24);  
        sss = size(control);

        stimuli = img_mask_v(:,[31:60,121:150,211:240]-24);


        h = zeros(sss(1),1);
        p = zeros(sss(1),1);

        for t = 1:sss(1)
            cl=control(t,:);
            sl=stimuli(t,:);
            if ~isnan(sum(cl))&&~isnan(sum(sl))

                [h(t,:),p(t,:),ks(t,:)] = kstest2(cl',sl','Alpha',0.01); %default Alphas = 0.05, you can change.
            else
                h(t,:) = 0;
                p(t,:) = 0;
                ks(t,:) = 0;
            end
        end
        % ks test result h: 0->related; 1->not related
        % convert to 1 -> significant
        hs = not(h);

        pmap = reshape(p,ss(1),ss(2),ss(3));
        hmap = reshape(hs,ss(1),ss(2),ss(3));
        chi2 = 4*ks.^2*(3*3*((3*3)/(3+3))); % ?
        chi2map = reshape(chi2,ss(1),ss(2),ss(3));

        save(['pmap_',prefix,'_01.mat'],'pmap')
        save(['hmap_',prefix,'_01.mat'],'hmap')
        save(['chi2map_',prefix,'_01.mat'],'chi2map')
        % .mat to .nii
        tmpt = spm_select('FPlist',pwd,['^',prefix,'.*.nii']);
        tmp = load_untouch_nii(tmpt);
        tmp.img = hmap;
        save_fakeuntouch_nii(tmp,['hmap_',prefix,'_01.nii']);
        tmp.img = pmap;
        save_fakeuntouch_nii(tmp,['pmap_',prefix,'_01.nii']);
         tmp.img = chi2map;
        save_fakeuntouch_nii(tmp,['chi2map_',prefix,'_01.nii']);

        clear tmp img img_mask img_mask_v pmap hmap
    else
        disp('result existed')
    end
   
end