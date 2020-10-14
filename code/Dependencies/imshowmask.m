function [outputArg1,outputArg2] = imshowmask(im,mask,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;

addRequired(p,'im')
addRequired(p,'mask');

addOptional(p,'color',[255 0 0],@isnumeric)
addOptional(p,'alpha',0.25,@islogical);

parse(p,im,mask,varargin{:});

mcolor = p.Results.color;
malpha = p.Results.alpha;

maskC(:,:,1) = mcolor(1).*mask;
maskC(:,:,2) = mcolor(2).*mask;
maskC(:,:,3) = mcolor(3).*mask;

alphaim = malpha.*double(mask);

hI = imshow(im);
hold on
hM = imshow(maskC);
hM.AlphaData = alphaim;
end

