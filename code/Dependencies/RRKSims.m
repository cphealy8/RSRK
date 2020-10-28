function [K,LminR,FPosition] = RRKSims(pts,win,r,nFrames,fOverlap,SigLvl,EdgeCorrection,varargin)
%RRK Rolling Ripley's K
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'pts',@isnumeric)
addRequired(p,'win',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'SigLvl',@isnumeric)
addRequired(p,'EdgeCorrection',@ischar)
addOptional(p,'PtsB',[],@isnumeric);
addOptional(p,'Mask',[]);

parse(p,pts,win,r,nFrames,fOverlap,SigLvl,EdgeCorrection,varargin{:})

PtsB = p.Results.PtsB;
Mask = p.Results.Mask;

% Compute Window Width
WinHeight = win(4)-win(3);
WinWidth = win(2)-win(1);
rLen = length(r);

% Compute Frame Dimensions
FWidth = WinWidth/(nFrames-nFrames*fOverlap+fOverlap);
% FWidth = floor(FWidth); 

FStarts = linspace(win(1),WinWidth-FWidth,nFrames);
FEnds = linspace(FWidth,win(2),nFrames);
FPosition = FEnds./WinWidth; % Frame position as fraction of window width.

% Preallocate
K = zeros(nFrames,rLen);
LminR = zeros(nFrames,rLen);

% Simulation parameters
msims = (2/SigLvl)-1;

%% Simulation
pbar = 0;
pbarmax = nFrames*msims;
tvec = nan(1,pbarmax);

hbar = waitbar(0,'');
for n=1:nFrames
%     CurFrame = [win(3) win(4) FStarts(n) FEnds(n)];
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    
    % Generate current mask.
    if ~isempty(Mask)
        CurMask = Mask(1:WinHeight,floor(FStarts(n)+1):floor(FEnds(n)));
    end
    
    % Compute current points and npts.
    if ~isempty(PtsB)
        CurPtsA = CropPts2Win(pts,CurFrame);
        CurPtsB = CropPts2Win(PtsB,CurFrame);
        
        CurPtsA = CurPtsA(:,1)-FStarts(n); % Re-zero
        CurPtsB = CurPtsB(:,1)-FStarts(n); % Re-zero
        
        nptsA = length(CurPtsA);
        nptsB = length(CurPtsB);
    else
        CurPts = CropPts2Win(pts,CurFrame);
        npts = length(CurPts);
        CurPts(:,1) = CurPts(:,1)-FStarts(n); % Re-zero
       end
    
    % Run simulations
    for m = 1:msims
        tic;
        if ~isempty(PtsB)
                if ~isempty(Mask)
                    RndPtsA = RandPPMask(nptsA,CurMask);
                    RndPtsB = RandPPMask(nptsB,CurMask);

                    [K(n,:,m),~,L] = Kmulti(RndPtsA,RndPtsB,CurFrame,'t',r,'Mask',CurMask);
                else

                    [K(n,:,m),~,L] = Kmulti(RndPtsA,RndPtsB,CurFrame,'t',r);
                end

        else % Univariate
            if ~isempty(Mask)
                RndPts = RandPPMask(npts,CurMask);
                [K(n,:,m),~,L] = Kest(RndPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection,'Mask',CurMask);
            else
                [K(n,:,m),~,L] = Kest(RndPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection);
            end
        end
        
        LminR(n,:,m) = L-r;
        
        % Update progress bar
        pbar = pbar+1;
        
        tvec(pbar) = toc;
        meantime = mean(tvec,'omitnan');
        ETR = round((pbarmax-pbar).*meantime/60);
        waitbar(pbar/pbarmax,hbar,sprintf('Simulating CSR Frame: %d/%d Sim:%d/%d \n Estimated Time Remaining: %d min',n,nFrames,m,msims,ETR))
    end
end
delete(hbar)

K = rot90(K);
LminR = rot90(LminR);
end

