function [pts] = RandPPMask(npts,mask)
%RANDPPMASK Randomly generates a point process in the area defined by a
%binary mask
%   Detailed explanation goes here

% % Determine the pixels that are not masked out.
% pixIDs = reshape(1:numel(mask),size(mask));
% 
% pixIn = pixIDs(mask);
% 
% MaskRez= size(mask');
% [maskx,masky] = meshgrid(0:MaskRez(1),0:MaskRez(2));
% maskx = maskx(:);
% masky = masky(:);
% 
% % Randomly generate the point process.
% rPixIDs = randsample(pixIn,npts);
% 
% % Randomly select the pixel coordinates in the mask.
% px = maskx(rPixIDs)+rand([npts 1]);
% py = masky(rPixIDs)+rand([npts 1]);
% 
% randPP = [px py];

% Set some useful parameters
ImgRes = size(mask');
MaskArea = sum(mask(:));
WindowArea = numel(mask);
PtDensity = npts/MaskArea;
InitPtCount = ceil(PtDensity*WindowArea);

% Randomly Generate points in the window.
pts = rand(InitPtCount,2).*ImgRes;
delN = 1; % Initialize

while delN~=0
    pts = CropPts2Mask(pts,mask);

    % Count the points
    [ncur,~] = size(pts); 
    delN = npts-ncur;
    
    if delN< 0
        pts(1:-delN,:)=[];
    elseif delN>0
        NNewPts = ceil(delN*2*WindowArea/MaskArea);
        NewPts = rand(NNewPts,2).*ImgRes;
        pts = [pts; NewPts];
    else
        break
end

end

