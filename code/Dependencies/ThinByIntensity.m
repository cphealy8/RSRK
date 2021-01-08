function [pts] = ThinByIntensity(IntensityMap,Win,pts,varargin)
%THINBYINTENSITY Thin a point process using an intensity map
%   [pts] = THINBYINTENSITY(IntensityMap,Win,pts) thins the point process
%   pts defined in the window Win = [xmin xmax ymin ymax] by the
%   IntensityMap. IntensityMap is a matrix that defines the probability.
%
%   [pts] = THINBYINTENSITY(IntensityMap,Win,pts,reps) performs the
%   thinning process as in the previous example. Optional 4th argument
%   (reps) a positive integer, specifies how many times the thinning 
%   process is repeated.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.
%% parse inputs
p = inputParser;
addRequired(p,'IntensityMap')
addRequired(p,'Win')
addRequired(p,'pts')
addOptional(p,'reps',1,@isnumeric)

parse(p,IntensityMap,Win,pts,varargin{:})

reps = p.Results.reps;
%%
IntensityMap = IntensityMap';
WinWidth = Win(2)-Win(1);
WinHeight = Win(4)-Win(3);

[xpix,ypix] = size(IntensityMap);
xscale = xpix/WinWidth;
yscale = ypix/WinHeight;

for n=1:reps
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

end
