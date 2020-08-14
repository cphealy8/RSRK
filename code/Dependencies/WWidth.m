function [WindowWidth,WindowHeight] = WWidth(mask,nFrames,fOverlap)
%WWIDTH Compute window width. 
%   Detailed explanation goes here
[WindowHeight,MaskWidth] = size(mask);
WindowWidth = MaskWidth/(nFrames-nFrames*fOverlap+fOverlap);
WindowWidth = floor(WindowWidth); 
end

