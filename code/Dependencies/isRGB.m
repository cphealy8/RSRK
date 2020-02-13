function [type] = isRGB(im)
%ISRGB Determine if input is an RGB image
%   Detailed explanation goes here

% By default the type is not rgb or false
type = 0;

%% Characterize the input
[sx,sy,~]=size(im);

L=length(size(im));

%% Test the input
% Requirements to be an RGB image
% - im is a 3D array
% - im is a stack of 2D arrays (sx and sy are both greater than 1.
% - The image is encoded as a uint8 image. 

if ((L==3) && sx>1 && sy>1 && isa(im,'uint8')==1)
    type = 1;
end

end

