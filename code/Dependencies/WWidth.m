function [WindowWidth,WindowHeight] = WWidth(mask,nFrames,fOverlap)
%WWIDTH Compute window width. 
%   [WindowWidth,WindowHeight] = WWIDTH(mask,nFrames,fOverlap) computes the
%   window width and window height given an input mask or image (this is
%   usually the original image that is being segmented into windows), a
%   target number of frames, and a target overlap between those frames.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 
[WindowHeight,MaskWidth] = size(mask);
WindowWidth = MaskWidth/(nFrames-nFrames*fOverlap+fOverlap);
WindowWidth = floor(WindowWidth); 
end

