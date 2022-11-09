% This script is to do the estimate and create contrast for data smoothed
% by FSL
clear
spm('defaults','fmri');
wkdir = '/g5/kirby/xmiao5/XZhou86/Model free method';
cd(wkdir)

datasdir=dir('*7T*');%^.*?(?<!ica)
all = {datasdir.name};
% exclude .ica folder
% ica = contains({datasdir.name},'.ica');
% all = cell(1,length(find(ica == 0)));
% n = 1;
% for i = 1: length(datasdir)
%     if ~ica(i)
%         all{n} = datasdir(i).name;
%         n=n+1;
%     end
% end
%%
for n=1:length(all)
    disp(all{n});
    datadir = fullfile(wkdir,all{n});
    cd(datadir)
    
    P = spm_select('ExtFPlist',pwd,['^f.*8_1.nii'],1:276);
    Pcell = cell(276,1);
    for i = 1:276
        Pcell{i} = P(i,:);
    end
    cd ('/g5/kirby/xmiao5/XZhou86/Model free method/1st_Level')
    if ~exist(all{n},'dir')
        mkdir(all{n})
    end
    
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {['/g5/kirby/xmiao5/XZhou86/Model free method/1st_Level/',all{n}]};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = Pcell;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.name = 'impulse';
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.onset = [0
                                                          2
                                                          4
                                                          6
                                                          8
                                                          10
                                                          12
                                                          14
                                                          16
                                                          18
                                                          20
                                                          22
                                                          24
                                                          26
                                                          28
                                                          30
                                                          32
                                                          34
                                                          36
                                                          38
                                                          40
                                                          42
                                                          44
                                                          46
                                                          48
                                                          50
                                                          52
                                                          54
                                                          56
                                                          58
                                                          60
                                                          62
                                                          64
                                                          66
                                                          68
                                                          70
                                                          72
                                                          74
                                                          76
                                                          78
                                                          80
                                                          82
                                                          84
                                                          86
                                                          88
                                                          90
                                                          92
                                                          94
                                                          96
                                                          98
                                                          100
                                                          102
                                                          104
                                                          106
                                                          108
                                                          110
                                                          112
                                                          114
                                                          116
                                                          118
                                                          120
                                                          122
                                                          124
                                                          126
                                                          128
                                                          130
                                                          132
                                                          134
                                                          136
                                                          138
                                                          140
                                                          142
                                                          144
                                                          146
                                                          148
                                                          150
                                                          152
                                                          154
                                                          156
                                                          158
                                                          160
                                                          162
                                                          164
                                                          166
                                                          168
                                                          170
                                                          172
                                                          174
                                                          176
                                                          178
                                                          180
                                                          182
                                                          184
                                                          186
                                                          188
                                                          190
                                                          192
                                                          194
                                                          196
                                                          198
                                                          200
                                                          202
                                                          204
                                                          206
                                                          208
                                                          210
                                                          212
                                                          214
                                                          216
                                                          218
                                                          220
                                                          222
                                                          224
                                                          226
                                                          228
                                                          230
                                                          232
                                                          234
                                                          236
                                                          238
                                                          240
                                                          242
                                                          244
                                                          246
                                                          248
                                                          250
                                                          252
                                                          254
                                                          256
                                                          258
                                                          260
                                                          262
                                                          264
                                                          266
                                                          268
                                                          270
                                                          272
                                                          274
                                                          276
                                                          278
                                                          280
                                                          282
                                                          284
                                                          286
                                                          288
                                                          290
                                                          292
                                                          294
                                                          296
                                                          298
                                                          300
                                                          302
                                                          304
                                                          306
                                                          308
                                                          310
                                                          312
                                                          314
                                                          316
                                                          318
                                                          320
                                                          322
                                                          324
                                                          326
                                                          328
                                                          330
                                                          332
                                                          334
                                                          336
                                                          338
                                                          340
                                                          342
                                                          344
                                                          346
                                                          348
                                                          350
                                                          352
                                                          354
                                                          356
                                                          358
                                                          360
                                                          362
                                                          364
                                                          366
                                                          368
                                                          370
                                                          372
                                                          374
                                                          376
                                                          378
                                                          380
                                                          382
                                                          384
                                                          386
                                                          388
                                                          390
                                                          392
                                                          394
                                                          396
                                                          398
                                                          400
                                                          402
                                                          404
                                                          406
                                                          408
                                                          410
                                                          412
                                                          414
                                                          416
                                                          418
                                                          420
                                                          422
                                                          424
                                                          426
                                                          428
                                                          430
                                                          432
                                                          434
                                                          436
                                                          438
                                                          440
                                                          442
                                                          444
                                                          446
                                                          448
                                                          450
                                                          452
                                                          454
                                                          456
                                                          458
                                                          460
                                                          462
                                                          464
                                                          466
                                                          468
                                                          470
                                                          472
                                                          474
                                                          476
                                                          478
                                                          480
                                                          482
                                                          484
                                                          486
                                                          488
                                                          490
                                                          492
                                                          494
                                                          496
                                                          498
                                                          500
                                                          502
                                                          504
                                                          506
                                                          508
                                                          510
                                                          512
                                                          514
                                                          516
                                                          518
                                                          520
                                                          522
                                                          524
                                                          526
                                                          528
                                                          530
                                                          532
                                                          534
                                                          536
                                                          538
                                                          540
                                                          542
                                                          544
                                                          546
                                                          548
                                                          550];
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond.orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.gamma.length = 1;
    matlabbatch{1}.spm.stats.fmri_spec.bases.gamma.order = 1;
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%     matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
%     matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%     matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'imp';
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0];
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%     matlabbatch{3}.spm.stats.con.delete = 0;
    
    spm_jobman('run',matlabbatch);
end

