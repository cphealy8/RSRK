%FLIPOLDDATASET switchess x and y coordinates of input point process and
%rotates mask/image file to match.
%
%   FLIPOLDDATASET prompts the user to select a mask file and a point
%   process then switches the x and y coordinates of the chosen point
%   process and rotates the mask/image file to match.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%%

clc;clear;close all;

[MaskFile,MaskPath]  = uigetfile('../data/*bmp','Select Mask File');
[PtFile,PtPath] = uigetfile(fullfile(MaskPath,'*mat'),'Select Points File');

oldMask = ~imread(fullfile(MaskPath,MaskFile));
load(fullfile(PtPath,PtFile));

Mask = rot90(oldMask',2);

[MaskH,MaskW] = size(Mask);
oldpts = cdata.RegionProps.Centroids;
pts = fliplr(oldpts);
pts = -pts+[MaskW MaskH];

imshow(Mask); hold on; plot(pts(:,1),pts(:,2),'.r')
%%
imwrite(Mask,fullfile(MaskPath,MaskFile))
save(fullfile(PtPath,PtFile),'pts')

