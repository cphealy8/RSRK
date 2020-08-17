clc; clear; close all;
addpath('Dependencies')
addpath('Dependencies\PPGenerators')

npts = 1000;
nreps = 199;
win = [0 5 0 1];
kFrames = [1:(win(2)*2-1)];
fOverlap = 0.5;
r = linspace(0,0.5,11);
r(1) = [];

%%
f = waitbar(0,'Running Simulations');
for n=1:nreps
    
    %% Place the filename for the point process you want to verify here.
    % Define a point process, and be sure that it the variable pts which is
    % a 2 column vector of coordinates. Place the script defining the point
    % process in the PPGenerators subdirectory. 
    PP01_RandomHomogenous
    
    %% Run Simulations 
    for k=1:length(kFrames)
        [~,L{n,k}] = RRK(pts,win,r,kFrames(k),fOverlap,'on');
    end
    waitbar(n/nreps)
end
close(f)

%% Save the simulated data
fdir = '..\data\Verification Tests';
fullfile(fdir,strcat(PPName,'.mat'))
