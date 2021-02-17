%RSRK_PLOT Plot and save RSRK Results
%   RSRK_PLOT generates plots from RSRK results then saves those plots.
%
%   RSRK_PLOT reads RSRKDat files saved within analysis folders within the
%   LoadDir directory specified within the USER INPUT Section of this
%   script (Note, if you used RSRK_Analysis.m to generate these data files
%   by default the RSRKDat files are already in the correct location).
%
%   Running this script will read the data files, generate RSRK Plots, then
%   save those plots as .pdf and .eps files to the Save Directory indicated
%   within the USER INPUT Section of this script. 
%   
%   Users can adjust the limits of the colorbars used in RSRK analysis by
%   changing the variable cLims in the USER INPUT section of this script.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

clc; clear; close all;
%% USER INPUT 
% Directory where data is located (same as analysis directory in
% RSRK_Analysis.m
LoadDir = '..\data\RSRK Data\';

% Directory where the graph pdfs are stored and saved. 
SaveDir = '..\results\RSRK\';

% Plotting Specs
cLims = [-0.3 0.3]; % Colorbar Limits

%% DON'T EDIT BELOW HERE
addpath('Dependencies');
DirDat = dir(LoadDir);
foldnames = {DirDat(3:end).name}';

cntr =0; %counter
for fID=1:length(foldnames)
    curFold = fullfile(LoadDir,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    isRKdata = contains(curFiles,'RSRKDat');
    
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
            minEnv = quantile(cRK.CSRSims,SigLvl/2)';
            maxEnv = quantile(cRK.CSRSims,1-SigLvl/2)';
            G(:,k) = log2(cRK.Obs./cRK.CSR)';
            IsSig(:,k) = (curK<=minEnv | curK>=maxEnv);
        end
        
        cntr =cntr+1;
        maxG(cntr) = max(G(:));
        minG(cntr) = min(G(:));

        [fH,axM,axH] = RSRK_Plot(r,FPosition,G,'SigMap',IsSig,'cLims',cLims);
        SaveFile = curFile(1:end-4);
        fH.Units = 'centimeters';
        fH.Position = [1 1 9.5 6.0];
        
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
