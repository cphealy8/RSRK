function [WindowWidth,WindowHeight] = WWidth(mask,nFrames,fOverlap)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[WindowHeight,MaskWidth] = size(mask);
WindowWidth = MaskWidth/(nFrames-nFrames*fOverlap+fOverlap);
WindowWidth = floor(WindowWidth); 
end

