clc; clear; close all;
addpath('Dependencies')

dirname = '..\data\Verification Tests\';
fnames = dir(dirname);
SaveDir = '..\results\Verification Tests';
minL = [];
maxL = [];
% cLims = [-0.0313 0.1210];

% Univariate patterns run from n=1:40+3;
% Bivariate patterns run from n=41:56 +3;

for n = 43:length(fnames)
% Test Stat

% Load the appropriate baseline statistic for each group of tests
if n<=43
    cLims = [-0.0313 0.1210];
    load('..\data\Verification Tests\PP01_RandomHomogenous.mat')
elseif n>43 || n<=59
    cLims = [-0.04 0.04];
    load('..\data\Verification Tests\PP41_RandomRandom1090Homogenous.mat')
end

KTest1 = K;

load('..\data\Verification Tests\PP34_RandomNonhomogenousPerpendicularS.mat')
KTest2= K;

% Target Stat
filename = fnames(n).name;
fulldir = fullfile(dirname,fnames(n).name);
load(fulldir)
KTarget = K;

%% LminR
means = cell2mat(RRK_Mean(L));
minL(n-2) = min(means(:));
maxL(n-2) = max(means(:));


% T = RRK_TTest2(KTarget,KTest1);
% T2 = RRK_TTest2(KTarget,KTest2);

nSD = 3;
T = RRK_SDRange(KTarget,KTest1,nSD);
T2 = RRK_SDRange(KTarget,KTest2,nSD);
if exist('ptsA','var') && exist('ptsB','var')
    [fH,~,~,maxM(n),minM(n)] = RRK_Verification_Plot(r,FPosition,L,ptsA,PPName,cLims,T,ptsB);
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
clear pts ptsA ptsB K L
end
