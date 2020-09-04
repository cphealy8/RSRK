clc;clear;close all;
win = [0 5 0 1];
npts = 1000;
addpath('..')

%% Put point process script name here
PP26_NonStationaryParallelNonhomogenousPerpendicular

%% Visualization
scale = 100;
f = figure('Position',[100 100 5*scale scale]);
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5);
axis image
axis(win);
ax = gca;
title(PPName);

PPDensity(pts,win)