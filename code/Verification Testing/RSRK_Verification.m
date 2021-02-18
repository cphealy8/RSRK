%RSRK_VERIFICATION Load Point Patterns and verify RSRK. 
%   This code reads in the verification point patterns defined in
%   Dependencies\PPGenerators and calculates RSRK. It repeats this process
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

%% DONT EDIT BELOW HERE
addpath('..\Dependencies')
addpath('..\Dependencies\PPGenerators')
dirname = '..\Dependencies\PPGenerators';
fnames = dir(dirname);

% Univariate patterns run from k=1:40;
% Bivariate patterns run from k=41:56;
% Signal patterns run from 57:80

for k = [(61+15) (112+15)]
% for k = (57+13):72
    fname = fnames(k).name;
    
    if contains(fname,'PP')
        f = waitbar(0,sprintf('Running simulation %d out of %d',k,length(fnames)));
        for n=1:nreps

                %% Place the filename for the point process you want to verify here.
                % Define a point process, and be sure that it the variable pts which is
                % a 2 column vector of coordinates. Place the script defining the point
                % process in the PPGenerators subdirectory.
                run(fname)
                
                if ~exist('Mask','var')
                    Mask = ones(size(Signal));
                end
                
                
                %% Run Simulations 
                for m=1:length(kFrames)
                    
                    if exist('mask1','var')&&exist('mask2','var')
                        [RK,FPosition{m}] = MovingRKSig(Signal,pts,r*imRez,mask1,'Pts2Sig',kFrames(m),0.5,1,'X');
                    else
                        [RK,FPosition{m}] = MovingRKSig(Signal,pts,r*imRez,Mask,'Pts2Sig',kFrames(m),0.5,1,'X');
                    end
                    
                    
                    tempStruct = cell2mat(RK);
                    FPosition{m} = FPosition{m}./imRez;
                    KObs{m}(:,:,n) = vertcat(tempStruct.Obs)';
                    KCSR{m}(:,:,n) = vertcat(tempStruct.CSR)';
                    
                    % Calling this K to simplify coding but it's really
                    % G(r). 
                    K{m}(:,:,n) = log2(KObs{m}(:,:,n)./KCSR{m}(:,:,n));
                end
                waitbar(n/nreps)

        end
        close(f)
        
        %% Save the simulated data
        fdir = '..\data\Verification Tests';
        [~,filename] = fileparts(fname);
        savedir = fullfile(fdir,strcat(filename,'.mat'));
        
        save(savedir,'Signal','KObs','KCSR','K','imRez','npts','win','r','PPName','FPosition','pts');

        clearvars -except npts nreps win kFrames fOverlap r fnames dirname k
    end
end

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
