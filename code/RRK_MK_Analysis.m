clc; clear; close all;
addpath('Dependencies')
%% Analysis Params
nFrames = 15;
fOverlap = 0.5;
imscale = 1.50; % pix/µm
SigLvl = 0.01;

% Analysis scales (r);
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm



Units = 'um';
ScaleUnits = 'um/pixel';

SaveDir = '..\results\Kokliaris Dataset\';

%% Loading Mask and Point Data
[MaskFile,MaskPath]  = uigetfile('../data/*bmp','Select Mask File');
[PtFile,PtPath] = uigetfile(fullfile(MaskPath,'*mat'),'Select Points File');
Mask = ~imread(fullfile(MaskPath,MaskFile));
load(fullfile(PtPath,PtFile));

rescale = 0.9;
rscaled = r*imscale*rescale; %[=] pixels  
Mask = imresize(Mask,rescale);
pts = rescale.*pts;
pts = CropPts2Mask(pts,Mask);


% pts = RandPPMask(length(pts),Mask);
%% Run Simulations
[MaskHeight,MaskWidth] = size(Mask);
win = [0 MaskWidth 0 MaskHeight];

[G,Sig,~,FPosition,cLims,KScaled,PercEx,KObs,KSims] = RRK_Norm(pts,rscaled,nFrames,fOverlap,SigLvl,'Mask',Mask);

%% Plot
[fH1,axM,axH] = RSRK_Plot(r,FPosition,PercEx,'SigMap',Sig,'cLims',cLims);
% [fH2,axM,axH] = RSRK_Plot(r,FPosition,KScaled,'SigMap',Sig);
%% Save the data

FileName = strcat(PtFile(1:end-4),'_RRK','.mat');
savedir = fullfile(MaskPath,FileName);
save(savedir,'r','pts','Mask','imscale','nFrames','fOverlap','SigLvl',...
    'G','Sig','FPosition','cLims','KScaled','PercEx','KObs','KSims');

% Save Figures
SaveFileG = strcat(PtFile(1:end-4),'_RRK_G');
SaveName = fullfile(SaveDir, SaveFileG);
saveas(fH1,SaveName,'pdf')
print(fH1,SaveName,'-dpng');   

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
