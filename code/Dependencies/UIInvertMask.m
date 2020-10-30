clc;clear;close all;

[MaskFile,MaskPath]  = uigetfile('../data/*bmp','Select Mask File');

Mask = ~imread(fullfile(MaskPath,MaskFile));

imwrite(Mask,fullfile(MaskPath,MaskFile))

