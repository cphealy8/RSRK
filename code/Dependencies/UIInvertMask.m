%%
% This code prompts a user to select a mask file (.bmp image) and then
% inverts it. 

%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 
%%
clc;clear;close all;

[MaskFile,MaskPath]  = uigetfile('../data/*bmp','Select Mask File');

Mask = ~imread(fullfile(MaskPath,MaskFile));

imwrite(Mask,fullfile(MaskPath,MaskFile))

