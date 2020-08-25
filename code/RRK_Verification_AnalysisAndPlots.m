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
% load('..\data\Verification Tests\PP06 - Mixed - Homogenous.mat')
load('..\data\Verification Tests\PP03 - Aggregated - Large Clusters - Homogenous.mat')
KTarget = K;
clear K L

% Test Stat
load('..\data\Verification Tests\PP01 - Random Homogenous.mat')
KTest = K;
clear K L

%% Comparison 
G = RRK_Log2Norm(KTarget,KTest);
% % means = cell2mat(RRK_Mean(G));
% % minG = round(min(means(:)),2)
% % maxG = round(max(means(:)),2)

% P = RRK_TTest2(KTarget,KTest);
% stat = RRK_ComparisonStat(KTarget,KTest);

[fH,pH] = RRK_Verification_Plot(r,FPosition,KTarget);
xlabel('Window Position');
ylabel('Scale (r)');