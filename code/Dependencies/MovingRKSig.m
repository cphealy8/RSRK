function [RK,x] = MovingRKSig(im,pts,r,mask,CompType,nFrames,fOverlap,SigLvls,Direction,varargin)
%MOVINGKRK Compute Ripley's K in a moving window. 
%   [RK,x] = MovingRK(pts,mask,WindowWidth,nFrames,SigLvls,Direction)
%   computes for the point process defined by the 2-column matrix of
%   coordinates pts in the area defined by the bitmap image (or logical
%   matrix) mask for nFrames in the image with overlaps equal to the
%   fraction given by fOverlap. Also computes significance envelopes for
%   the significance levels passed to SigLvls e.g. (SigLvls = [0.01 0.05].
%   The direction that the window moves is specified by passing either 'X'
%   or 'Y' for along the x or y axes respectively. Finally the user can
%   specify a second mask, as a variable argument, to specify the region
%   in which random simulation of the point process is carried out. This is
%   useful when the point process and signal do not necessarily overlap.
%   
%   CompType specifies the type of calculation 'Pts2Sig' or 'Sig2Pts'. 
%
%   SEE ALSO RKENVELOPE, RKSIMPLE. 

ptsize= size(pts);

% Check for non 2D inputs
if length(ptsize)~= 2 || ~ismember(2,ptsize)
    error('pts must be a 2-column matrix of cartesian coordinates')
end

% Force 2-column format
if ptsize(2)>ptsize(1)
    pts = pts'; 
end

% This code will assume that the window moves from left to right (X). If the
% user specifies Bottom to Top (Y) the x and y coordinates of the points
% should be swapped.
if nargin ==10
    mask2 = varargin{1};
end

if strcmp(Direction,'Y')
    pts = fliplr(pts);
    mask = mask';
    if nargin==10
        mask2 = mask2';
    end
    im = im';
elseif ~strcmp(Direction,'X')
    error('Invalid Direction')
end

% Apply Mask to Signal Image
im(~mask) = 0;

[MaskHeight,MaskWidth] = size(mask);

% Set WindowWidth
[WindowWidth,WindowHeight] = WWidth(mask,nFrames,fOverlap);

if MaskWidth<WindowWidth
    error('WindowWidth must be smaller than the area of the point process.')
end

iStart = floor(linspace(1,MaskWidth-WindowWidth+1,nFrames));
iStop = iStart+(WindowWidth-1);
xStart = iStart-1;
xStop = iStop;
dX = cumsum([0 diff(xStart)]);



% Window by Window select the points to analyze, then perform Ripley's K.
% hw = waitbar(0,sprintf('Computing Window (0/%d)',nFrames));
for n = 1:nFrames
    ptsXIn = (pts(:,1)>xStart(n) & pts(:,1)<xStop(n));
    CurPts = pts(ptsXIn,:);
    CurPts(:,1) = CurPts(:,1)-dX(n); % -dX used to align with mask.
    npts = length(CurPts);
    CurMask = mask(:,iStart(n):iStop(n));
    CurIm = im(:,iStart(n):iStop(n));
    
    if nargin==10
        CurMask2 = mask2(:,iStart(n):iStop(n));
        RK{n} = RKSigEnv(CurIm,CurPts,r,CurMask,SigLvls,CompType,CurMask2);
    else
        RK{n} = RKSigEnv(CurIm,CurPts,r,CurMask,SigLvls,CompType);
    end
    
%     waitbar(n/nFrames,hw,sprintf('Computing Window (%d/%d)',n,nFrames))
    
    RK{n}.WindowWidth = WindowWidth;
    RK{n}.WindowHeight = WindowHeight;
    RK{n}.WinBounds = [iStart(n) iStop(n)];
    RK{n}.Window = n;
    RK{n}.Pts = CurPts;
    RK{n}.Mask = CurMask;
end
delete(hw)

x = xStart;
end

function [pts] = ZeroPoints(pts,type)
switch type
    case 'XY'
        pts(:,1) = pts(:,1)-min(pts(:,1));
        pts(:,2) = pts(:,2)-min(pts(:,2));
    case 'X'
        pts(:,1) = pts(:,1)-min(pts(:,1));
    case 'Y'
        pts(:,2) = pts(:,2)-min(pts(:,2));
end

end


