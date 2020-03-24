clc; clear; close all;
addpath('Dependencies')
% Load data
[PtFile,PtPath] = uigetfile('../data/FullPts/*.mat','Select Full Points File');
[ImFile,ImPath] = uigetfile('../data/images/*png','Select Signal Image');
[MaskFile,MaskPath] = uigetfile('../data/images/*bmp','Select Mask File');
[MaskFile2,MaskPath2] = uigetfile('../data/images/*bmp','Select Mask File');


load(strcat(PtPath,PtFile))
pts = cdata.RegionProps.Centroids;
mask = ~imread(strcat(MaskPath,MaskFile));
mask2 = ~imread(strcat(MaskPath2,MaskFile2));
im = imread(strcat(ImPath,ImFile));

%% Settings for Coutu Images
% Rescale the image and points (Downsample for computational time);
rescale = 0.1; % Coutu
% rescale = 0.5; % Bone Phantoms
pts = pts*rescale;
mask = imresize(mask,rescale);
mask2 = imresize(mask2,rescale);
im = imresize(im,rescale);

Scale = 0.69/rescale; % µm/pixel (Coutu)
% Scale = 4.53/rescale; % µm/pixel (Bone Phantoms)

Units = 'Pixels';
ScaleUnits = 'um/pixel';
% Moving Window Settings
FrameOverlap = 0.5;
nFrames = 20;
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
[RK,x] = MovingRKSig(im,pts,r,mask,CompType,nFrames,FrameOverlap,SigLvls,'Y',mask2);

fdir = strcat('../data/MovingRK/MovingRKdata_',PtFile(4:end-12),'_',ImFile(4:end-4),'_',TimeID,'.mat');
% fout = fileupdate(fdir,ftype);
save(fdir,'RK','x','FrameOverlap','SigLvls','nFrames','mask','pts','r','Scale','Units','ScaleUnits');


S = load('gong'); 
sound(S.y,S.Fs);