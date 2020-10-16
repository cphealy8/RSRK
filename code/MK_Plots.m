clc; clear; close all;
addpath('Dependencies');
dirname = '..\data\Kokliaris Dataset\';
DirDat = dir(dirname);
foldnames = {DirDat(3:end).name}';
SaveDir = '..\results\Kokliaris Dataset\';

% selpath = uigetdir('../data');
% [datFile,datPath] = uigetfile('../data/*mat','Load Data File');
% load(fullfile(datPath,datFile));

%%
sigLvl = 0.05;
cLims = [-0.3 0.3];
cntr =0;
%%
for fID=1:length(foldnames)
    curFold = fullfile(dirname,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    isRKdata = contains(curFiles,'MKRK');
    
    RKdatafiles = curFiles(isRKdata);
    
    for datID=1:length(RKdatafiles)
        curFile = RKdatafiles{datID};
        load(fullfile(curFold,curFile));
        
        if ~exist('r','var')
            r= RK{1}.r;
        end
        if ~exist('FPosition','var')
            FPosition =x;
        end
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
        
        cntr =cntr+1;
        maxG(cntr) = max(G(:));
        minG(cntr) = min(G(:));

        [fH,axM,axH] = RSRK_Plot(r,FPosition,G,'SigMap',IsSig,'cLims',cLims);
        SaveFile = curFile(1:end-4);
        
        ylabel(axH,'Scale r (µm)')
        yticklabels(axH,r)
        yticklabels(axM,[]);
        xlabel(axM,'Window Position')
        xticklabels(axM,[]);
        
        % Save results
        SaveName = fullfile(SaveDir, SaveFile);
        saveas(fH,SaveName,'pdf')
        print(fH,SaveName,'-dpng');
        
        close all
        
        clear r FPosition G IsSig
    end
end
