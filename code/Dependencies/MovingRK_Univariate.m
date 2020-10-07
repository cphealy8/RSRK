clc; clear; close all;

% Load data
[PtFile,PtPath] = uigetfile('../data/FullPts/*.mat','Select Full Points File');
[MaskFile,MaskPath] = uigetfile('../data/images/*bmp','Select Mask File');

load(strcat(PtPath,PtFile))
pts = cdata.RegionProps.Centroids;
mask = imread(strcat(MaskPath,MaskFile));

% Make sure the mask is not inverted.
mask = CheckMask(mask,0.1);

% Moving Window Settings
FrameOverlap = 0.5;
nFrames = 20;   
Scale = 0.69; % µm/pixel

r = logspace(log10(10),log10(500),20); % [=] um
r = r./Scale; % [=] pixels. 

% Monte-Carlo Simulation Settings
SigLvls = [0.05 0.01];
fname = strcat(PtFile(1:end-12),'_Univ');
pdir = '..\data\MovingRK';

[RK,x] = MovingRK(pts,r,mask,nFrames,FrameOverlap,SigLvls,'Y');

Name = fname;
Units = 'Pixels';
ScaleUnits = 'um/pixel';

fdir = fullfile(pdir,strcat(fname,'_',TimeID,'.mat'));
save(fdir,'RK','x','FrameOverlap','nFrames','mask','pts','r','Name','Scale','Units','ScaleUnits');

S = load('gong');
sound(S.y,S.Fs);