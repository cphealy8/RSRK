clc; clear; close all;
addpath('Dependencies')

dirname = '..\data\Verification Tests\';
fnames = dir(dirname);
SaveDir = '..\results\Verification Tests';
minL = [];
maxL = [];
% cLims = [-0.0313 0.1210];

% Univariate patterns run from n=1:42
% Bivariate patterns run from n=43:58
% Signal patterns run from n=59:80

ct=0; 
for n= 96:length(fnames)
%  for n = 77

% Test Stat
fname = fnames(n).name;
% Load the appropriate baseline statistic for each group of tests
if n<=42
    cLims = [-0.0313 0.1210];
    load('..\data\Verification Tests\PP001_RandomHomogenous.mat')
elseif n>42 && n<=58
    cLims = [-0.04 0.04];
    if contains(fname,'1090')
        load('..\data\Verification Tests\PP041_RandomRandom1090Homogenous.mat')
    elseif contains(fname,'5050')
        load('..\data\Verification Tests\PP042_RandomRandom5050Homogenous.mat')
    end
elseif n>=59
    if contains(fname,'Pts2Sig')
        cLims = [-1.5 1.5];
        load('..\data\Verification Tests\PP060_Pts2Sig_RandomHomogenous.mat'); % Control for Sig2Pts tests
    elseif contains(fname,'Self')
        cLims = [-2.5 2.5];
        load('..\data\Verification Tests\PP081_Self_PtsRandomSigRandom.mat'); % Control for Self Tests
    end
end

KTest1 = inf2nan(K);

load('..\data\Verification Tests\PP034_RandomNonhomogenousPerpendicularS.mat')
KTest2= inf2nan(K);

% Target Stat
filename = fnames(n).name;
fulldir = fullfile(dirname,fnames(n).name);
load(fulldir)
KTarget = inf2nan(K);


if contains(filename,'Self')
    ct=ct+1;
    mK(ct) = min(min(cell2mat(RRK_Mean(KTarget))));
    MK(ct) = max(max(cell2mat(RRK_Mean(KTarget))));
end


%% LminR
means = cell2mat(RRK_Mean(L));
minL(n-2) = min(means(:));
maxL(n-2) = max(means(:));

means = cell2mat(RRK_Mean(KTarget));
minK(n-2) = min(means(:));
maxK(n-2) = max(means(:));


% T = RRK_TTest2(KTarget,KTest1);
% T2 = RRK_TTest2(KTarget,KTest2);

if contains(fname,'Self')||contains(fname,'Pts2Sig')
    [~,T] = RRK_TTest2(KObs,KCSR,1e-4);
else
    nSD = 3;
    T = RRK_SDRange(KTarget,KTest1,nSD);
end

if exist('ptsA','var') && exist('ptsB','var')
    [fH,~,~,maxM(n),minM(n)] = RRK_Verification_Plot(r,FPosition,L,ptsA,PPName,cLims,T,'ptsB',ptsB);
elseif exist('Signal','var')
    for m = 1:length(FPosition)
        maxF = max(FPosition{m});
        if numel(FPosition{m})==1
            FPosition{m}=0;
        else
            FPosition{m} = FPosition{m}./maxF;
        end
    end
    
    [fH,~,~,maxM(n),minM(n)] = RRK_Verification_Plot(r,FPosition,KTarget,pts,PPName,cLims,T,'Signal',Signal);
else
    [fH,~,~,maxM(n),minM(n)] = RRK_Verification_Plot(r,FPosition,L,pts,PPName,cLims,T);
end
% colorbar('southoutside')
% xlabel('Window Position');
% ylabel('Scale (r)');

SaveName = fullfile(SaveDir, filename(1:end-4));

saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng')

close all;

%% G (normalized)
% G = RRK_Log2Norm(KTarget,KTest);
% Glims = [-1.3168 4.2511];
% 
% [fH1,pH1] = RRK_Verification_Plot(r,FPosition,G,pts,PPName,Glims);
% 
% SaveName = fullfile(SaveDir, filename(1:end-4));
% SaveName = strcat(SaveName,' - G');
% 
% saveas(fH1,SaveName,'pdf')
% print(fH1,SaveName,'-dpng')

%% TTest 

% Tlims = 'pval';
% 
% [fH2] = RRK_TTest_Plot(r,FPosition,T,pts,PPName);
% 
% SaveName = fullfile(SaveDir, filename(1:end-4));
% SaveName = strcat(SaveName,' - TT');
% 
% saveas(fH2,SaveName,'pdf')
% print(fH2,SaveName,'-dpng')
clear pts ptsA ptsB K L Signal Mask
end
