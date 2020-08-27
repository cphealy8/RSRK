% clc; clear; close all;
% addpath('Dependencies')
% load('..\data\Verification Tests\PP01 - Random Homogenous.mat')
% means = cell2mat(RRK_Mean(L));
% minL = round(min(means(:)),4);
% maxL = round(max(means(:)),4);
% 
% [fH,pH] = RRK_Verification_Plot(r,FPosition,L);

%% Normalizing
clc; clear; close all;
dirname = '..\data\Verification Tests\';
fnames = dir(dirname);
SaveDir = '..\results\Verification Tests';
minL = [];
maxL = [];
for n = 3:length(fnames)
clearvars -except dirname fnames n SaveDir minL maxL

filename = fnames(n).name;
fulldir = fullfile(dirname,fnames(n).name);
load(fulldir)
% KTarget = K;


% Test Stat
% load('..\data\Verification Tests\PP01 - Random Homogenous.mat')
% KTest = K;
% clear K L

%% Comparison 
% G = RRK_Log2Norm(KTarget,KTest);
means = cell2mat(RRK_Mean(L));
minL(n-2) = min(means(:));
maxL(n-2) = max(means(:));

% P = RRK_TTest2(KTarget,KTest);
% stat = RRK_ComparisonStat(KTarget,KTest);

[fH,pH] = RRK_Verification_Plot(r,FPosition,L,pts,PPName);
xlabel('Window Position');
ylabel('Scale (r)');

SaveName = fullfile(SaveDir, filename(1:end-4));

saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng')

close all;
end
