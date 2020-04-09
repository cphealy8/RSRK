clc; clear; close all;
addpath('Dependencies')
% Load data
[PtFile,PtPath] = uigetfile('../data/Phantoms/*.mat','Select Full Points File');
[ImFile,ImPath] = uigetfile('../data/Phantoms/*png','Select Signal Image');
[MaskFile,MaskPath] = uigetfile('../data/Phantoms/*bmp','Select Signal Mask File');
[MaskFile2,MaskPath2] = uigetfile('../data/Phantoms/*bmp','Select Simulation Mask File');


load(strcat(PtPath,PtFile))
pts = cdata.RegionProps.Centroids;
mask = ~imread(strcat(MaskPath,MaskFile));
mask2 = ~imread(strcat(MaskPath2,MaskFile2));
im = imread(strcat(ImPath,ImFile));

%% Settings for Coutu Images
% Rescale the image and points (Downsample for computational time);
rescale = 0.5; % Coutu
pts = pts*rescale;
mask = imresize(mask,rescale);
mask2 = imresize(mask2,rescale);
im = imresize(im,rescale);

% Scale = 1/rescale; % µm/pixel % Base Phantoms
Scale = 4.53/rescale; % µm/pixel % Bone Phantoms
Units = 'Pixels';
ScaleUnits = 'µm/pixel';
% Moving Window Settings
FrameOverlap = 0.5;
nFrames = 20;
[wheight,wlength] = size(im);
windowwidth = wlength/(nFrames-nFrames*FrameOverlap+FrameOverlap);
rmax = round(windowwidth/2,-1);
r = logspace(log10(10),log10(500),10); % [=] um.          
r = r/Scale; % Scale [=] pixels;

%% Settings for TestImages
% Rescale the image and points (Downsample for computational time);
% rescale = 0.1; % Coutu
% pts = pts*rescale;
% mask = imresize(mask,rescale);
% im = imresize(im,rescale);
% 
% Scale = 1/rescale; % µm/pixel
% Units = 'Pixels';
% ScaleUnits = 'um/pixel';
% % Moving Window Settings
% FrameOverlap = 0.5;
% nFrames = 10;
% r = [25:25:200];       
% r = r/Scale; % Scale [=] pixels;

%% Make sure the mask is not inverted and correct if it is. 
mask = CheckMask(mask,0.1);  
mask2 = CheckMask(mask2,0.1);
% Monte-Carlo Simulation Settings
SigLvls = [0.05 0.01];
CompType = 'Pts2Sig';
[RK,x] = MovingRKSig(im,pts,r,mask,CompType,nFrames,FrameOverlap,SigLvls,'X',mask2);

dirparts = split(PtPath,'\');
fname = dirparts{6};
fdir = strcat(PtPath,'RK -',fname,'.mat');
% fout = fileupdate(fdir,ftype);
save(fdir,'RK','x','FrameOverlap','SigLvls','nFrames','mask','pts','r','Scale','Units','ScaleUnits');


S = load('gong'); 
sound(S.y,S.Fs);