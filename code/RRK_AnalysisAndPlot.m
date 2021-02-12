clc; clear; close all;
addpath('Dependencies')
%% Analysis Params
dirname = '..\data\RSRK Data\';

nFrames = 15;
fOverlap = 0.5;
imscale = 1.50; % pix/µm
SigLvl = 0.01;

% Analysis scales (r);
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm

Units = 'um';
ScaleUnits = 'um/pixel';
%%
% SaveDir = '..\..\results\Kokliaris Dataset\';
% 
% %% Loading Mask and Point Data
% [MaskFile,MaskPath]  = uigetfile('../../data/*bmp','Select Mask File');
% [PtFile,PtPath] = uigetfile(fullfile(MaskPath,'*mat'),'Select Points File');
% Mask = ~imread(fullfile(MaskPath,MaskFile));
% load(fullfile(PtPath,PtFile));
% 
% rescale = 1/(r(1)*imscale); % [=] pixDRez/pix (if min r = 5)
% rscaled = r*imscale*rescale; %[=] pixels  
% Mask = imresize(Mask,rescale);
% pts = rescale.*pts;
% pts = CropPts2Mask(pts,Mask);

%% Loading Params data
DirDat = dir(dirname);
if isempty(DirDat)
    mkdir(dirname)
    DirDat = dir(dirname);
end

foldnames = {DirDat(3:end).name}';
foldnames(contains(foldnames,'pool'))=[];
if isempty(foldnames)
    warning(strcat(dirname,' contains no data. Analysis terminated.'))
end

%% Analyze
for fID=1:length(foldnames)
    curFold = fullfile(dirname,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    
    % PP file extraction
    PtFiles = curFiles(contains(curFiles,'PP'));
    if isempty(PtFiles)
        error(strcat(curFold,' does not contain a point process file.',...
            ' This must be a .mat file with "PP" in the filename'))
    end
    
    % Mask file extraciton
    MaskName = curFiles(contains(curFiles,'ppmask'));
    if isempty(MaskName)
        error(strcat(curFold,' does not contain a mask file.',...
            'This must be a .bmp file with "ppmask" in the filename'))
    end
    MaskName = MaskName{1};
    Mask = ~imread(fullfile(curFold,MaskName));
    
    fID = fopen(fullfile(curFold,'imscale.txt'));
    imscale = cell2mat(textscan(fID,'%f'));
    fclose(fID);
    rescale = 1/(r(1)*imscale); % [=] pixDRez/pix (if min r = 5)
    %% Scaling and Frames
    % Rescale the image and points (Downsample for computational time);
    MaskA = imresize(Mask,rescale);
    
    Scale = imscale*rescale; % pixDRez/µm
    rA = r*Scale;
    
for pID = 1:length(PtFiles)
    PtsName = PtFiles{pID};
    load(fullfile(curFold,PtsName));
    ptsA = pts*rescale;
    
    hm = msgbox(sprintf('Now analyzing %s',PtsName));
%% Run Simulations
[MaskHeight,MaskWidth] = size(Mask);
win = [0 MaskWidth 0 MaskHeight];

[G,Sig,~,FPosition,~,KScaled,PercEx,KObs,KSims] = RRK_Norm(ptsA,rA,nFrames,fOverlap,SigLvl,'Mask',MaskA);

%% Plot
cLims = [-max(abs(PercEx(:))) max(abs(PercEx(:)))];
[fH1,axM,axH] = RSRK_Plot(r,FPosition,PercEx,'SigMap',Sig,'cLims',cLims);
xlabel('Frame Position (x)');
ylabel('Scale (r)');
cb=colorbar;
ylabel(cb,'Percent Excess Points versus CSR')
%% Save the data
PPIdentifier = extractBetween(PtsName,'PP_','.mat');
FileName = strcat('RRKDat_',PPIdentifier{1},'.mat');
savedir = fullfile(curFold,FileName);
save(savedir,'r','pts','Mask','imscale','nFrames','fOverlap','SigLvl',...
    'G','Sig','FPosition','cLims','KScaled','PercEx','KObs','KSims');

% Save Figures

SaveName = fullfile(curFold,'Results',FileName(1:end-4));
mkdir(fullfile(curFold,'Results'))
saveas(fH1,SaveName,'pdf')
print(fH1,SaveName,'-dpng');   
close(hm)
end
end

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
