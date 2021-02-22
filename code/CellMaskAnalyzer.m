%CELLMASKANALYZER estimate cell diameters and nearest neighbor distances.
%   CELLMASKANALYZER prompts the user to select a .bmp mask file that marks
%   cells (or other roughly circular features) in an image and a point
%   process file that marks the coordinates of these features. With these
%   inputs it estimates the diameter of the cells based upon the binary
%   mask. Additionally, using the point process it computes the nearest
%   neighbor distribution. 
%
%   These results are saved to the same directory as the mask file with the
%   prefix NNDist. 
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.
%%
clc;clear;close all;

[ImFile,ImPath] = uigetfile('../../data/*bmp','Select Cell Mask File');
[ppFile,ppPath] =uigetfile(ImPath,'Select PP File');

cellmask = imread(fullfile(ImPath,ImFile));
load(fullfile(ppPath,ppFile))

imshow(cellmask)
hold on
plot(pts(:,1),pts(:,2),'.r')

imscale = 1.5; % [px/µm]

%% Cell Morphology analysis
props = regionprops(cellmask,'EquivDiameter');
Diam = [props.EquivDiameter]/imscale;

%% Nearest Neighbor analysis
PDist = pairdist(pts,pts);
PDist(PDist==0)=inf;
NNDist = min(PDist)/imscale;

%% Save Results
fname =  strcat(ImFile(1:end-4),'_CellProps.mat');
save(fullfile(ImPath,fname),'Diam','NNDist');
