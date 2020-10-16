function [Frames] = Crop2Frames(im,nFrames,fOverlap)
%CROP2FRAMES Crop an image into separate frames.
%   Frame = CROP2FRAMES crops the image im into a number of Frames
%   (nFrames) equally spaced across the image that overlap by a fraction
%   (fOverlap). fOverlap = 0 produces frames with no overlap. fOverlap=0.5
%   produces frames that overlap by 50% of the framewidth. 

[~,imWidth] = size(im);
if length(nFrames)==1
[FrameWidth] = WWidth(im,nFrames,fOverlap);

iStart = floor(linspace(1,imWidth-FrameWidth+1,nFrames));
iStop = iStart+(FrameWidth-1);

% Crop windows and analyze.
Frames = cell(1,nFrames);
for n = 1:nFrames
    Frames{n} = im(:,iStart(n):iStop(n));
end

end

