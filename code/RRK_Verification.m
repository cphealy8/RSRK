clc; clear; close all;
addpath('Dependencies')
addpath('Dependencies\PPGenerators')

npts = 1000;
nreps = 199;
win = [0 5 0 1];
kFrames = [1:(win(2)*2-1)];
fOverlap = 0.5;
r = logspace(log10(0.01),log10(0.5),11);
r(1) = [];

%%
tic
f = waitbar(0,'Running Simulations');
for n=1:nreps
    
    %% Place the filename for the point process you want to verify here.
    % Define a point process, and be sure that it the variable pts which is
    % a 2 column vector of coordinates. Place the script defining the point
    % process in the PPGenerators subdirectory. 
    PP26_NonStationaryParallelNonhomogenousPerpendicular
    
    %% Run Simulations 
    for k=1:length(kFrames)
        [~,L{k}(:,:,n),FPosition{k}] = RRK(pts,win,r,kFrames(k),fOverlap,'on');
    end
    waitbar(n/nreps)
end
close(f)

%% Save the simulated data
fdir = '..\data\Verification Tests';
filename = fullfile(fdir,strcat(PPName,'.mat'));
save(filename,'L','npts','win','r','PPName','FPosition');

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
toc