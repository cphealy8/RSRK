function [K,LminR,FPosition] = RRKMask(pts,r,nFrames,fOverlap,Mask,varargin)
%RRK Rolling Ripley's K
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'pts',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'Mask');

addOptional(p,'PtsB',[],@isnumeric);


parse(p,pts,r,nFrames,fOverlap,Mask,varargin{:})

PtsB = p.Results.PtsB;
EdgeCorrection = 'off';

[maskHeight,maskWidth]=size(Mask);

win = [0 maskWidth 0 maskHeight];

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
%% Simulation

for n=1:nFrames
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    
    % Generate current mask.
    CurMask = Mask(1:WinHeight,floor(FStarts(n)+1):floor(FEnds(n)));
    
    % Compute current points and npts.
    if ~isempty(PtsB)
        CurPtsA = CropPts2Win(pts,CurFrame);
        CurPtsB = CropPts2Win(PtsB,CurFrame);
        
        CurPtsA = CurPtsA(:,1)-FStarts(n); % Re-zero
        CurPtsB = CurPtsB(:,1)-FStarts(n); % Re-zero
        
    else
        CurPts = CropPts2Win(pts,CurFrame);
        CurPts(:,1) = CurPts(:,1)-FStarts(n); % Re-zero
    end
    
    % Run simulations
    if ~isempty(PtsB)
            [K(n,:),~,L] = Kmulti(CurPtsA,CurPtsB,CurFrame,'t',r,'Mask',CurMask);
    else % Univariate
            [K(n,:),~,L] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection,'Mask',CurMask);
    end

    LminR(n,:) = L-r;
end

K = K';
LminR = LminR';
end

