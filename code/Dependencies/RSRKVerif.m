function [K,LminR,FPosition] = RSRKVerif(pts,signal,win,r,imRez,nFrames,fOverlap,varargin)
%RRK Rolling Ripley's K
%   Detailed explanation goes here

% Scale to match
r = imRez*r; % Scale to match signal image.
win = win*imRez;

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

% mask
if isempty(varargin)
    mask = ones(size(signal));
else 
    mask = varargin{1};
end
    

for n=1:nFrames
    CurFrame = [FStarts(n) FEnds(n) win(3) win(4)];
    CurPts = CropPts2Win(pts,CurFrame);
    CurPts(:,1) = CurPts(:,1)-FStarts(n);
    CurMask = mask(:,floor(FStarts(n))+1:floor(FEnds(n)));
    CurSignal = signal(:,floor(FStarts(n))+1:floor(FEnds(n)));
    
    % Catch errors
    if isempty(CurPts)
        K(n,:) = NaN;
    elseif sum(mask(:)==1)==0
        K(n,:) = NaN;
    else
        K(n,:) = RKSignal2Pts(CurSignal,CurPts,r,CurMask);
    end
    
    L = sqrt(K(n,:)/pi);
    LminR(n,:) = L-r;
    
end
K = K';
LminR = LminR';
end

