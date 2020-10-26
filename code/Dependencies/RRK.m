function [K,LminR,FPosition] = RRK(pts,win,r,nFrames,fOverlap,EdgeCorrection,varargin)
%RRK Rolling Ripley's K
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'pts',@isnumeric)
addRequired(p,'win',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'EdgeCorrection',@ischar)
addOptional(p,'PtsB',[],@isnumeric);
addOptional(p,'Mask',[],@isnumeric);

parse(p,pts,win,r,nFrames,fOverlap,EdgeCorrection,varargin{:})

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

for n=1:nFrames
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    
    % Generate current mask.
    if ~isempty(Mask)
        CurMask = Mask(CurFrame(1):CurFrame(2),CurFrame(3):CurFrame(4));
    end
    
    if ~isempty(PtsB)
        CurPtsA = CropPts2Win(pts,CurFrame);
        CurPtsB = CropPts2Win(PtsB,CurFrame);
        
        if ~isempty(Mask)
            [K(n,:),~,L] = Kmulti(CurPtsA,CurPtsB,CurFrame,'t',r,'Mask',CurMask);
        else
            [K(n,:),~,L] = Kmulti(CurPtsA,CurPtsB,CurFrame,'t',r);
        end
        
        
    else % Univariate
        CurPts = CropPts2Win(pts,CurFrame);
        
        if ~isempty(Mask)
            [K(n,:),~,L] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection,'Mask',CurMask);
        else
            [K(n,:),~,L] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection);
        end
    end
    
    LminR(n,:) = L-r;
    
end
K = K';
LminR = LminR';
end

