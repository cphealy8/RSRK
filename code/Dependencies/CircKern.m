function [kern] = CircKern(radius)
%CIRCKERN Generate circular binary kernel
%   Detailed explanation goes here
filt = fspecial('disk',radius);
kern = filt>0;
end

