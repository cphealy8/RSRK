%RRK_VERIFICATION Load Point Patterns and verify RRK. 
%   This code reads in the verification point patterns defined in
%   Dependencies\PPGenerators and calculates RRK. It repeats this process
%   for a number of times equal to nreps, calculates and outputs the
%   results of each repetition.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

clc; clear; close all;
%% USER INPUT
npts = 1000; % Number of points in simulated Point Process
nreps = 199; % Number of repetitions
win = [0 5 0 1]; % Simulated pattern dimensions [xmin xmax ymin ymax]
kFrames = [1 5 10 25]; % No. of Frames to test
fOverlap = 0.5; % Frame Overlap
r = logspace(log10(0.01),log10(0.5),11); % Scale (r)

%%
addpath('..\Dependencies')
addpath('..\Dependencies\PPGenerators')
dirname = '..\Dependencies\PPGenerators';
fnames = dir(dirname);

% Univariate patterns run from k=1:40;
% Bivariate patterns run from k=41:56;

for k = (1:56)+15
% for k = [18]
    
    fname = fnames(k).name;
    if contains(fname,'PP')
        f = waitbar(0,sprintf('Running simulation %d out of %d',k,length(fnames)));
        for n=1:nreps

                %% Place the filename for the point process you want to verify here.
                % Define a point process, and be sure that it the variable pts which is
                % a 2 column vector of coordinates. Place the script defining the point
                % process in the PPGenerators subdirectory.
                run(fname)
                
                %% Run Simulations 
                for k=1:length(kFrames)
                    if exist('ptsA','var')&&exist('ptsB','var') % bivariate case
                        [K{k}(:,:,n),L{k}(:,:,n),FPosition{k}] = RRK(ptsA,win,r,kFrames(k),fOverlap,'on',ptsB);
                    else
                        [K{k}(:,:,n),L{k}(:,:,n),FPosition{k}] = RRK(pts,win,r,kFrames(k),fOverlap,'on');
                    end
                end
                waitbar(n/nreps)

        end
        close(f)
        
        %% Save the simulated data
        fdir = '..\data\Verification Tests';
        [~,filename] = fileparts(fname);
        savedir = fullfile(fdir,strcat(filename,'.mat'));
        
        if exist('ptsA','var')&&exist('ptsB','var') % bivariate case
            save(savedir,'K','L','npts','win','r','PPName','FPosition','ptsA','ptsB');
        else % univariate case
            save(savedir,'K','L','npts','win','r','PPName','FPosition','pts');
        end

    end
end

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
