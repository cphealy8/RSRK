function [K,LminR,FPosition] = RRK(pts,win,r,nFrames,fOverlap,EdgeCorrection)
%RRK Rolling Ripley's K
%   Detailed explanation goes here

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
    CurPts = CropPts2Win(pts,CurFrame);
    
    [K(n,:),~,L] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection);
    LminR(n,:) = L-r;
    
end
K = K';
LminR = LminR';
end

