%% Code to summarize and analyze results of RSRK_TimingTesting.m simulation
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.
%%
clc;clear; close all;
load('..\..\data\Timing\RunTimeTable.mat')
dat.nreps = 2./dat.siglvl-1;
dat.timeperrep = dat.runtime./dat.nreps;

plot(dat.kframes,dat.timeperrep,'.r')
scatter3(dat.kframes,dat.npts,dat.timeperrep)