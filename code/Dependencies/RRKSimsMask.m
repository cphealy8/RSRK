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
addOptional(p,'PtsB',[],@isnumeric);


parse(p,pts,r,nFrames,fOverlap,SigLvl,Mask,varargin{:})

PtsB = p.Results.PtsB;

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
%% Simulation
pbar = 0;
pbarmax = nFrames*msims;
tvec = nan(1,pbarmax);

hbar = waitbar(0,'');
for n=1:nFrames
%     CurFrame = [win(3) win(4) FStarts(n) FEnds(n)];
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    
    % Generate current mask.

    CurMask = Mask(1:WinHeight,floor(FStarts(n)+1):floor(FEnds(n)));
    A(n) = sum(CurMask(:));

    
    % Compute current points and npts and KObs
    if ~isempty(PtsB)
        CurPtsA = CropPts2Win(pts,CurFrame);
        CurPtsB = CropPts2Win(PtsB,CurFrame);
        
        CurPtsA = CurPtsA(:,1)-FStarts(n); % Re-zero
        CurPtsB = CurPtsB(:,1)-FStarts(n); % Re-zero
        
        nptsA = length(CurPtsA);
        nptsB = length(CurPtsB);
        
        [~,~,~,~,~,~,EObs(n,:)] = Kmulti(CurPtsA,CurPtsB,CurFrame,'t',r,'Mask',CurMask);    
    else
        CurPts = CropPts2Win(pts,CurFrame);
        npts(n) = length(CurPts);
        CurPts(:,1) = CurPts(:,1)-FStarts(n); % Re-zero
        
        [~,~,~,~,~,~,EObs(n,:)] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection','off','Mask',CurMask);
    end

    
    % Compute Simulated RRK
    for m = 1:msims
        tic;
        if ~isempty(PtsB)
            RndPtsA = RandPPMask(nptsA,CurMask);
            RndPtsB = RandPPMask(nptsB,CurMask);

            [~,~,~,~,~,~,ESims(n,:,m)] = Kmulti(RndPtsA,RndPtsB,CurFrame,'t',r,'Mask',CurMask);    
        else % Univariate
            RndPts = RandPPMask(npts(n),CurMask);
            [~,~,~,~,~,~,ESims(n,:,m)] = Kest(RndPts,CurFrame,'t',r,'EdgeCorrection','off','Mask',CurMask);
        end
        
        
        % Update progress bar
        pbar = pbar+1;
        
        tvec(pbar) = toc;
        meantime = mean(tvec,'omitnan');
        ETR = round((pbarmax-pbar).*meantime/60);
        waitbar(pbar/pbarmax,hbar,sprintf('Simulating CSR Frame: %d/%d Sim:%d/%d \n Estimated Time Remaining: %d min',n,nFrames,m,msims,ETR))
    end
end
delete(hbar)

LInv = A./(npts.*(npts-1)); % Inverse lambda (density)

KObs = bsxfun(@times,EObs,LInv');
KSims = bsxfun(@times,ESims,LInv');

end

