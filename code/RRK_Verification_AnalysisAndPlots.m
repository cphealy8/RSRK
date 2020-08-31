clc; clear; close all;
addpath('Dependencies')

dirname = '..\data\Verification Tests\';
fnames = dir(dirname);
SaveDir = '..\results\Verification Tests';
minL = [];
maxL = [];
cLims = [-0.0313 0.1210];
for n = 3:length(fnames)

% Test Stat
load('..\data\Verification Tests\PP01 - Random Homogenous.mat')
KTest = K;

% Target Stat
filename = fnames(n).name;
fulldir = fullfile(dirname,fnames(n).name);
load(fulldir)
KTarget = K;




%% LminR
means = cell2mat(RRK_Mean(L));
minL(n-2) = min(means(:));
maxL(n-2) = max(means(:));

% P = RRK_TTest2(KTarget,KTest);
% stat = RRK_ComparisonStat(KTarget,KTest);

[fH,pH] = RRK_Verification_Plot(r,FPosition,L,pts,PPName,cLims);
xlabel('Window Position');
ylabel('Scale (r)');

SaveName = fullfile(SaveDir, filename(1:end-4));

saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng')

close all;

%% G (normalized)
G = RRK_Log2Norm(KTarget,KTest);
Glims = [-1.3168 4.2511];

[fH1,pH1] = RRK_Verification_Plot(r,FPosition,G,pts,PPName,Glims);

SaveName = fullfile(SaveDir, filename(1:end-4));
SaveName = strcat(SaveName,' - G');

saveas(fH1,SaveName,'pdf')
print(fH1,SaveName,'-dpng')

%% TTest 
T = RRK_TTest2(KTarget,KTest);
Tlims = 'pval';

% [fH2,pH2] = RRK_Verification_Plot(r,FPosition,T,pts,PPName,Tlims);
% 
% SaveName = fullfile(SaveDir, filename(1:end-4));
% SaveName = strcat(SaveName,' - TT');

% saveas(fH2,SaveName,'pdf')
% print(fH2,SaveName,'-dpng')

end
