clc; clear; close all;
addpath('Dependencies')
addpath('Dependencies\PPGenerators')

npts = 1000;
nreps = 199;
win = [0 5 0 1];
% kFrames = [1:(win(2)*2-1)];
kFrames = [1 5 10 25];
fOverlap = 0.5;
r = logspace(log10(0.01),log10(0.5),11);
r(1) = [];

%%

dirname = 'Dependencies\PPGenerators';
fnames = dir(dirname);

for k = 1:length(fnames)
    
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
                    [K{k}(:,:,n),L{k}(:,:,n),FPosition{k}] = RRK(pts,win,r,kFrames(k),fOverlap,'on');
                end
                waitbar(n/nreps)

        end
        close(f)
        
        %% Save the simulated data
        fdir = '..\data\Verification Tests';
        [~,filename] = fileparts(fname);
        savedir = fullfile(fdir,strcat(filename,'.mat'));
        save(savedir,'K','L','npts','win','r','PPName','FPosition','pts');
    end
end

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
