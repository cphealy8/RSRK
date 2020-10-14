   clc; clear; close all;
addpath('Dependencies')
starttime = clock;
%% Analysis Params
% nFrames = 15;
FrameWidth = 2000; %[=]um

fOverlap = 0.5;
rescale = 1/7.5; % [=] pixDRez/pix
imscale = 1.50; % pix/µm
SigLvls = [0.05];

% Analysis scales (r);
% r = [10 20 30 50 90 160 290 500]; %[=] µm
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm

Units = 'um';
ScaleUnits = 'um/pixel';

%% Load data
[ImFile,ImPath] = uigetfile('../data/*png','Select Signal Image');
[MaskFile,MaskPath] = uigetfile(fullfile(ImPath,'*bmp'),'Select Mask File');
[PtFile,PtPath] = uigetfile(fullfile(ImPath,'*mat'),'Select Points File');

Signal = imread(fullfile(ImPath,ImFile));
mask = ~imread(fullfile(MaskPath,MaskFile));
load(strcat(PtPath,PtFile));

%% Scaling and Frames
framewidth = FrameWidth*imscale;

[SHeight,SWidth] = size(Signal);
[nFrames,fOverlap] = compFrames(SWidth,fOverlap,framewidth); 

% Rescale the image and points (Downsample for computational time);
  pts = pts*rescale;
mask = imresize(mask,rescale);
Signal = imresize(Signal,rescale);

Scale = imscale*rescale; % pixDRez/µm
r = r*Scale;

% Apply masks if needed
% if contains(ImFile,'_R')
%     Signal = Signal.*mask;
% end

%% Analysis
npts = length(pts);

[RK,FPosition] = MovingRKSig(Signal,pts,r,mask,'Pts2Sig',nFrames,fOverlap,SigLvls,'X');

tempStruct = cell2mat(RK);
KObs = vertcat(tempStruct.Obs)';
KCSR = vertcat(tempStruct.CSR)';

% Convert back to original scale
r = r/Scale;
FPosition = FPosition/Scale;
                    
% Calling this K to simplify coding but it's really G(r). 
K = log2(KObs./KCSR);

endtime = clock;

TimeElapsed = etime(endtime,starttime)/60;
        
%% Save the data
FileRoot = ImFile(1:end-4);
FileName = strcat(FileRoot,'_MKRK.mat');
savedir = fullfile(ImPath,FileName);
save(savedir,'RK','Signal','KObs','KCSR','K','npts','r','FPosition',...
    'pts','nFrames','mask','imscale','rescale','TimeElapsed','FrameWidth','nFrames','fOverlap');


S(1) = load('gong');
sound(S(1).y,S(1).Fs)
