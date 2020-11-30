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