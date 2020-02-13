%% RSRK Full
addpath('Dependencies')
% This script will step through the full process of computing RSRK,
% including segmenting an image to obtain a point process, computing RSRK
% statistics, and plotting the results. Note, the mask used in computing
% RSRK MUST already be defined. 
% Note RSRK will be computed according to the parameters specified in the
% dependent scripts below. Parameters such as the number of windows, and
% window overlap must be changed in MovingRK_Bivariate_Pts2Signal. 
% Plotting parameters can be changed within MovingRKPlot
clc; clear; close all;
%% Obtain Point Process
% Select and image and convert it into a point process. Click close to
% progress to next step.
mySegment;


%% Compute RSRK 
% Prompts user to select input point process, signal image and mask then 
% computes RSRK. Also displays progress of RSRK calculation. At
% termination, this script will prompt the user to save the RSRK results. 
MovingRK_Bivariate_Pts2Signal;

%% Graph Results
% Prompts the user to select RSRK data to graph, graps the data, then
% automatically saves the graphics.
MovingRKPlot;