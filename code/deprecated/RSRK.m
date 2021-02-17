clc; clear; close all;
addpath('..\Dependencies')
%
%% RSRK Input Parameters
% Image Settings
DownsamplingPerc = 0.1; % Downsampling percentage.
ImScale = 0.69; % Image scale Units/pixel
Units = 'Pixels';
ScaleUnits = 'um/pixel';

% Moving Window Settings
WindowOverlap = 0.5;
nWindows = 20;

% Vector defining the scales to be analyzed by RSRK  
r = logspace(log10(10),log10(500),10); 

%% Load appropriate files
addpath('Dependencies')
% Load data
[PtFile,PtPath] = uigetfile('../data/FullPts/*.mat','Select Full Points File');
[ImFile,ImPath] = uigetfile('../data/images/*png','Select Signal Image');
[MaskFile,MaskPath] = uigetfile('../data/images/*bmp','Select Mask File');

msg = msgbox('Loading Input Data. Please wait.');

load(strcat(PtPath,PtFile))
pts = cdata.RegionProps.Centroids;
mask = ~imread(strcat(MaskPath,MaskFile));
im = imread(strcat(ImPath,ImFile));
delete(msg)

%% Settings for RSRK
% Rescale the image and points (Downsample for computational time);

pts = pts*DownsamplingPerc;
mask = imresize(mask,DownsamplingPerc);
im = imresize(im,DownsamplingPerc);

Scale = ImScale/DownsamplingPerc; % Image Resolution µm/pixel
         
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
% Monte-Carlo Simulation Settings
SigLvls = [0.05 0.01];
CompType = 'Pts2Sig';
[RK,x] = MovingRKSig(im,pts,r,mask,CompType,nWindows,WindowOverlap,SigLvls,'Y');

fdir = strcat('../data/MovingRK/MovingRKdata_',PtFile(4:end-12),'_',ImFile(4:end-4),'_',TimeID,'.mat');
% fout = fileupdate(fdir,ftype);
save(fdir,'RK','x','FrameOverlap','SigLvls','nFrames','mask','pts','r','Scale','Units','ScaleUnits');


S = load('gong'); 
sound(S.y,S.Fs);
