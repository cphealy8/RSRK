function [pts] = CropPts2Mask(pts,mask)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[MaskHeight, MaskWidth] = size(mask);
% make sure all points are within the full area of the mask

checkx = (pts(:,1)<0 | pts(:,1)>MaskWidth);
checky = (pts(:,2)<0 | pts(:,2)>MaskHeight);
ptsOut = (checkx | checky);
if sum(ptsOut)~= 0
    warning('Points outside the mask were removed')
end
pts(ptsOut,:) = [];


%%%%%%%%
mask = mask';
imrez = size(mask); 
npixels = prod(imrez);

% Convert points to pixel IDs
ptpixID = pts2pix(pts,imrez);

% Determine which pixels are in the mask and those which are not. 
linMask = mask(:);
pixIDList = (1:npixels)';

PixIN = linMask.*pixIDList;
PixIN(PixIN==0) = [];

PixOUT = ~linMask.*pixIDList;
PixOUT(PixOUT==0) = [];

delVec = ismember(ptpixID,PixOUT);
pts(delVec,:) = [];

end



