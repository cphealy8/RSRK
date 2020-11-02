function [Frames] = Crop2Frames(im,nFrames,fOverlap,varargin)
%CROP2FRAMES Crop an image into separate frames.
%   Frame = CROP2FRAMES crops the image im into a number of Frames
%   (nFrames) equally spaced across the image that overlap by a fraction
%   (fOverlap). fOverlap = 0 produces frames with no overlap. fOverlap=0.5
%   produces frames that overlap by 50% of the framewidth. 
type = 'im';
if ~isempty(varargin)
    type = 'pts';
    pts = varargin{1};
end

[imHeight,imWidth] = size(im);
if length(nFrames)==1
[FrameWidth] = WWidth(im,nFrames,fOverlap);

iStart = floor(linspace(1,imWidth-FrameWidth+1,nFrames));
iStop = iStart+(FrameWidth-1);

% Crop windows and analyze.
Frames = cell(1,nFrames);
for n = 1:nFrames
    switch type
        case 'im'
            Frames{n} = im(:,iStart(n):iStop(n));
        case 'pts'
            win = [iStart(n) iStop(n) 0 imHeight];
            Frames{n} = CropPts2Win(pts,win);
    end
end  
end


