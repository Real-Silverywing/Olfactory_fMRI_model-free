%for each ROI, polt the mean/std timecourse. save the figure in jpg, and
%ppt.
%
clear

wkdir = '/g5/kirby/xmiao5/XZhou86/';  % enter data path
cd(wkdir)

datadir=dir('**/2*.ica');

all = {datadir.name};
des = {datadir.folder};

% roiname = {'OB','Parahip_AAL','Temporal_Pole_AAL','Figure_1B_MNI152_ROI_1mm','Amy_exPiri',...
%     'OFC_AAL','Hipp_AAL','Caudate_AAL','Putamen_AAL','Thalamus_AAL','Temporal_Sup_AAL','Insula_AAL',...
%     'Cingulate_Ant_AAL','Cingulate_Post_AAL','Cingulate_Mid_AAL'};
roiname = {'MNI_OB_manual','Figure_1B_MNI152_ROI_1mm','Insula_AAL','OFC_AAL','Amy_exPiri_AAL',...
    'Temporal_Sup_AAL','Temporal_Pole_AAL','Putamen_AAL','Caudate_AAL','Thalamus_AAL',...
    'Cingulate_Post_AAL','Cingulate_Mid_AAL','Cingulate_Ant_AAL','Parahip_AAL','Hipp_AAL'};
titlename = {'Olfactory bulb','Parahippocampus','Temporal Pole','Primary olfactory','Amygdala'...
    'Orbitofrontal','Hippocampus','Caudate','Putamen','Thalamus','Superior Temporal','Insula',...
    'Anterior Cingulate','Posterior Cingulate','Middle Cingulate',};%'Olfactory bulb',

prefix = 'wfilterpp3';%prefix2 = 'pp6';prefix4='p1';
%thr = '8';
%%
figure;
for r=1:length(roiname)
    
     x = [(1:length(all))];%,(17:length(all))];
    for n=1:length(all)%1:6%1:length(all)%1:14%1:length(all)%%%%%%%%:5
          cd ([wkdir,all{x(n)}])
%             c = spm_select('FPlist',pwd,['^deltatimec.*COposi_','.*',prefix,'.*', roiname{r},'.*.mat']);
            c = spm_select('FPlist',pwd,['^deltatimec.*COposi_','.*',prefix, roiname{r},'.*.mat']);
       
      
        load(c)
        
        
        deltabposi = deltabposi;

        if isempty(deltabposi)
        else
            %y=deltab*100;
            y=deltabposi*100;
            t=1:276;
            %
            ya(:,n)=y;
           
        end
        
        
    end
    hold on;
    if r ==1
        subplot(8,2,r)
        
         ylim([-1 1.2])
        yticks([-1,0,1])
        % yticklabels({'-2','0','2','4'}) %posi
        yticklabels({'-1','0','1'}) %neg
        rectangle('Position',[31-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
        
        rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
        rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',
        
    else
        
        subplot(8,2,r+1)
        rectangle('Position',[31-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
        
        rectangle('Position',[121-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)
        rectangle('Position',[211-24, 0, 29,0.8],'EdgeColor','black','LineWidth',1.5)  %'EdgeColor','blue',
        
          ylim([-1 1])
        yticks([-1,0,1])
        %yticklabels({'-1','0','1','2'}) %posi
        yticklabels({'-1','0','1'})  %neg
        
       end
    hold on;
    line([1,276],[0,0],'LineWidth',1.5,'Color','black')
    line([7,36],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
    line([97,126],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
    line([187,216],[0,0],'LineWidth',2,'Color','white','LineStyle',':')
    
    s=shadedErrorBar(t,ya',{@mean,@ster});
    s.edge(1).LineWidth=1;
    s.edge(2).LineWidth=1;
    
    s.edge(1).LineStyle=':';
    s.edge(2).LineStyle=':';
    s.mainLine.LineWidth = 2;
    xlim([0 277])
  
    xticks([50:50:250])
    xticklabels({'100','200','300','400','500'})
    vn = spm_select('FPlist','/g5/kirby/xmiao5/XZhou86/ROI',['^voxeln.*posi','.*',roiname{r},'.*.mat']);
           
    load(vn)
    voxeln = length(indexp);
    title(strcat(titlename{r},num2str(voxeln)))
    
    set(gcf,'units','inches','position',[0,0,12,9])
    
    %clear y d dd tdd ty
end
cd(wkdir)
savefig(['aResult/subj_groupPDnew_mean_shaded_posi01_filtCO.fig'])%prefix2,prefix4,
print(gcf,['aResult/subj_groupPDnew_shaded_ks_final_posi01_filtCO',prefix,'.png'],'-dpng');

addToPPT(strcat('aResult/subj_groupPDnew_shaded_ks_final_posi01_filtCO',prefix,'.png'),strcat('/g5/kirby/xmiao5/XZhou86/aResult/result5.pptx'),roiname{r})

function r=ster(data)
r=std(data)/sqrt(size(data',2));
end
