function [pts] = ThinByIntensity(IntensityMap,Win,pts)
%Thin a point process using an intensity map
%   [pts] = ThinByIntensity(IntensityMap,Win,pts) thins the point process
%   pts defined in the window Win = [xmin xmax ymin ymax] by the
%   IntensityMap. IntensityMap is a matrix that defines the probability 
IntensityMap = IntensityMap';
WinWidth = Win(2)-Win(1);
WinHeight = Win(4)-Win(3);

[xpix,ypix] = size(IntensityMap);
xscale = xpix/WinWidth;
yscale = ypix/WinHeight;

pts = pts.*[xscale yscale];

% convert pts to pixels
ptpixID = pts2pix(pts,[xpix ypix]);

% Check and convert intensity map
IntensityMap = double(IntensityMap);
IntMax = max(IntensityMap(:));

if IntMax>1
  IntensityMap = IntensityMap./IntMax;
end

ptIntensity = IntensityMap(ptpixID);

OmitThese = ptIntensity<rand(length(ptpixID),1);

pts(OmitThese,:) = []; % Delete the points in Omit These.

pts = pts./[xscale yscale];
end
