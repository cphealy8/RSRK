function [KObs,KSims,FPosition,EObs,ESims,A,npts] = RRKSimsMask(pts,r,nFrames,fOverlap,SigLvl,Mask,varargin)
%RRKSimsMask Compute observed Ripley's K and Ripley's K under simulated CSR
%using a Rolling window approach. 
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'pts',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'SigLvl',@isnumeric)
addRequired(p,'Mask');


parse(p,pts,r,nFrames,fOverlap,SigLvl,Mask,varargin{:})


[MaskHeight,MaskWidth] = size(Mask);

win = [0 MaskWidth 0 MaskHeight];

% Compute Window Width
WinHeight = win(4)-win(3);
WinWidth = win(2)-win(1);
rLen = length(r);

% Compute Frame Dimensions
FWidth = WinWidth/(nFrames-nFrames*fOverlap+fOverlap);

FStarts = linspace(win(1),WinWidth-FWidth,nFrames);
FEnds = linspace(FWidth,win(2),nFrames);
FPosition = FEnds./WinWidth; % Frame position as fraction of window width.

% Simulation parameters
msims = (2/SigLvl)-1;

% Preallocate
EObs = zeros(nFrames,rLen);
ESims = zeros(nFrames,rLen,msims);
A = zeros(nFrames,1);
npts = zeros(nFrames,1);

%% Simulation
pbar = 0;
pbarmax = nFrames*msims;
tvec = nan(1,pbarmax);

hbar = waitbar(0,'');

for n=1:nFrames
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    
    % Generate current mask
    CurMask = Mask(1:WinHeight,floor(FStarts(n)+1):floor(FEnds(n)));
    A(n) = sum(CurMask(:)); % Save Area

    % Compute current points and npts and KObs
    CurPts = CropPts2Win(pts,CurFrame);
    npts(n) = length(CurPts); % Save Number of Points
    CurPts(:,1) = CurPts(:,1)-FStarts(n); % Re-zero
    
    % Compute observed E
    [~,~,~,~,~,~,EObs(n,:)] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection','off','Mask',CurMask);
    
    % Compute Simulated RRK
    for m = 1:msims
        tic;

        RndPts = RandPPMask(npts(n),CurMask); % Shuffle points
        
        % Compute simulated value
        [~,~,~,~,~,~,ESims(n,:,m)] = Kest(RndPts,CurFrame,'t',r,'EdgeCorrection','off','Mask',CurMask);
        
        
        %% Update progress bar
        pbar = pbar+1;
        % Time estimation
        tvec(pbar) = toc;
        meantime = mean(tvec,'omitnan');
        ETR = round((pbarmax-pbar).*meantime/60); % Estimated Time Remaining
        waitbar(pbar/pbarmax,hbar,sprintf('Simulating CSR Frame: %d/%d Sim:%d/%d \n Estimated Time Remaining: %d min',n,nFrames,m,msims,ETR))
    end
end

delete(hbar)

% Conver E's to K's using point process density.
LInv = A./(npts.*(npts-1)); % Inverse lambda (density)

KObs = bsxfun(@times,EObs,LInv');
KSims = bsxfun(@times,ESims,LInv');

end

