%CXCL12SEGMENTER automatically segment and identifiy CXCL12+ cells in
%immunofluorescent images from Kokkaliaris database. 
%   This script prompts the user to select an rgb image to segment in which
%   CXCL12+ cells are assigned to the green channel of the image. It
%   extracts the green channel then performs a sequence of morphological
%   operations to isolate CXCL12+ cells in the image. It then outputs the
%   segmented image as a binary mask in which white regions mark CXCL12+
%   cells. This masked image can then be used to generate a point process
%   that marks CXCL12+ cells. 
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%%
clc; clear; close all;

% Quick CXCL12 segmentation
[ImFile,ImPath] = uigetfile('../../data/*png','Select RGB Image to Segment');
RAW = imread(fullfile(ImPath,ImFile));

G = RAW(:,:,2);

Thresh = G;
Thresh(Thresh<150)= 0;
Thresh(Thresh>0) = 1;
Thresh = logical(Thresh);

IC = imclose(Thresh,strel('disk',2));
IO = imopen(IC,strel('disk',2));

maskname = strcat('CXCL12','CellMask.bmp');
imwrite(IO,fullfile(ImPath,maskname));