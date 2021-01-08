clc; clear; close all;
addpath('Dependencies')
% Load data
[PtFile,PtPath] = uigetfile('../data/Phantoms/*.mat','Select Full Points File');
[ImFile,ImPath] = uigetfile('../data/Phantoms/*png','Select Signal Image');
[MaskFile,MaskPath] = uigetfile('../data/Phantoms/*bmp','Select Mask File');

load(strcat(PtPath,PtFile))
pts = cdata.RegionProps.Centroids;
mask = ~imread(strcat(MaskPath,MaskFile));
im = imread(strcat(ImPath,ImFile));

%% Settings for Coutu Images
% % Rescale the image and points (Downsample for computational time);
% rescale = 0.1; % Coutu
% pts = pts*rescale;
% mask = imresize(mask,rescale);
% im = imresize(im,rescale);
% 
% Scale = 0.69/rescale; % µm/pixel
% Units = 'Pixels';
% ScaleUnits = 'um/pixel';
% % Moving Window Settings
% FrameOverlap = 0.5;
% nFrames = 20;
% r = logspace(log10(10),log10(500),10); % [=] um.           
% r = r/Scale; % Scale [=] pixels;

%% Settings for TestImages
% Rescale the image and points (Downsample for computational time);
rescale = 0.24; % Coutu
pts = pts*rescale;
mask = imresize(mask,rescale);
im = imresize(im,rescale);

Scale = 1/rescale; % µm/pixel
Units = 'Pixels';
ScaleUnits = 'pixels/pixel';
% Moving Window Settings
FrameOverlap = 1;
nFrames = 1;
r = (2.5:2.5:50)*418/100; % [=] pixels.     
r = r/Scale; % Scale [=] pixels;

%% Make sure the mask is not inverted and correct if it is. 
mask = CheckMask(mask,0.1);  
% Monte-Carlo Simulation Settings
SigLvls = [0.05 0.01];
CompType = 'Pts2Sig';
[RK,x] = MovingRKSig(im,pts,r,mask,CompType,nFrames,FrameOverlap,SigLvls,'X');

dirparts = split(PtPath,'\');
fname = dirparts{6};
fdir = strcat(PtPath,'RK -',fname,'.mat');
% fout = fileupdate(fdir,ftype);
save(fdir,'RK','x','FrameOverlap','SigLvls','nFrames','mask','pts','r','Scale','Units','ScaleUnits');

S = load('gong'); 
sound(S.y,S.Fs);
