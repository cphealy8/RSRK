function [kern] = CircKern(radius)
%CIRCKERN Generate circular binary kernel
%   [kern] = CircKern(5) generates a binary kernel (matrix of zeros and
%   ones) with a radius of 5. (the matrix will contain a circle of 1's with
%   a radius of 5, all other entries are zero). This is the same as a
%   binary mask of a circle.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%%
filt = fspecial('disk',radius);
kern = filt>0;
end

