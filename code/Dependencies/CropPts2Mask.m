function [pts] = CropPts2Mask(pts,mask)
%CROPPTS2MASK Crop points to an irregular region (mask)
%   [croppedpts] = CropPts2Mask(pts,mask) removes points that fall within
%   the black region of the input mask and outputs the results. The mask
%   should be a binary matrix of zeros and ones that define the regions to
%   keep (1) and the regions to omit (0). The point coordinates should be
%   in the same units as the mask (usually pixels). 
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%
%   SEE ALSO Crop2Frames
%%
[MaskHeight, MaskWidth] = size(mask);
% make sure all points are within the full area of the mask

try
    checkx = (pts(:,1)<0 | pts(:,1)>MaskWidth);
    checky = (pts(:,2)<0 | pts(:,2)>MaskHeight);
catch
    pts = pts';
    checkx = (pts(:,1)<0 | pts(:,1)>MaskWidth);
    checky = (pts(:,2)<0 | pts(:,2)>MaskHeight);   
end

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



