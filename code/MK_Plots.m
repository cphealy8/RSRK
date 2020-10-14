clc; clear; close all;
selpath = uigetdir('../data');
% [datFile,datPath] = uigetfile('../data/*mat','Load Data File');
% load(fullfile(datPath,datFile));

%%
sigLvl = 0.05;
nr = length(r);
nframes = length(FPosition);
G = zeros(nr,nframes);
IsSig = zeros(nr,nframes);

FPosition= FPosition./(max(FPosition));

for k=1:length(RK)
    cRK = RK{k};
    curK = cRK.Obs';
    minEnv = quantile(cRK.CSRSims,sigLvl/2)';
    maxEnv = quantile(cRK.CSRSims,1-sigLvl/2)';
    G(:,k) = log2(cRK.Obs./cRK.CSR)';
    IsSig(:,k) = (curK<=minEnv | curK>=maxEnv);
end

RSRK_Plot(r,FPosition,K,'SigMap',IsSig);
