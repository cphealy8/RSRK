% Code for running RSRK under a variety of parameters in order to assess
% performance and runtime.

%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.
%% Parameters. 
clc;clear;close all;

onpts = [500 1000 1500]; % no. of simulated points
okframes = [1 3 10]; % no. of simulated frames
orezX = [10 32 100]; % Image resolution multiplier
onr = [5 10 15]; % No. of simulated distance scales (r)
oSigLvls = 2./([10 32 100]+1); % Simulated significance levels. 

%% Generate all permutations of parameters above
[X1,X2,X3,X4,X5]= ndgrid(onpts,okframes,orezX,onr,oSigLvls);
tbl = [X1(:) X2(:) X3(:) X4(:) X5(:)];
%% Run RSRK and time. 
runt= zeros(1,length(tbl));
for k = 1:length(tbl)
npts = tbl(k,1);
kFrames = tbl(k,2);
rezX = tbl(k,3);
nr = tbl(k,4);
SigLvl = tbl(k,5);

r = rezX*(1/nr:1/nr:1);
sz = rezX*[2 5];

fOverlap = 0.5;


Signal = ones(sz(1),sz(2));
mask = logical(Signal);
pts = RandPPMask(npts,logical(Signal));

tStart = tic;
[RK] = MovingRKSig(Signal,pts,r,mask,'Pts2Sig',kFrames,fOverlap,SigLvl,'X');
runt(k) = toc(tStart);
end

%% Save results
dat = array2table([tbl runt'],'VariableNames',{'npts','kframes','rezx','nr','siglvl','runtime'});
dat.kframes = round(dat.kframes);
save('..\..\data\Timing\RunTimeTable.mat','dat')