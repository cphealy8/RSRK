function [K,LminR] = RRK(pts,win,r,nFrames,fOverlap,EdgeCorrection)
%RRK Rolling Ripley's K
%   Detailed explanation goes here

% Compute Window Width
WinHeight = win(4)-win(3);
WinWidth = win(2)-win(1);

% Compute Frame Dimensions
FWidth = WinWidth/(nFrames-nFrames*fOverlap+fOverlap);
FWidth = floor(FWidth); 

FStarts = linspace(win(1),WinWidth-FWidth,nFrames);
FEnds = linspace(FWidth,win(2),nFrames);

% Preallocate
K = cell(1,nFrames);
LminR = cell(1,nFrames);

for n=1:nFrames
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    CurPts = CropPts2Win(pts,CurFrame);
    
    [K{n},~,L] = Kest(CurPts,CurFrame,'t',r,'EdgeCorrection',EdgeCorrection);
    LminR{n} = L-r;
end

end

