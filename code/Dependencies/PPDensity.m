function [density] = PPDensity(pts,win)
%PPDENSITY Compute the density of a point process
%   [density] = PPDensity(pts,win) computes the density of the input point
%   process pts, defined as a 2-column vector of coordinates, in the window
%   win = [xmin xmax ymin ymax];
%
%   [density] = PPDensity(npts,win) computes the density of a point process
%   with a number of points given by npts in the window win = [xmin xmax
%   ymin ymax];
%
%

Area = (win(2)-win(1))*(win(4)-win(3));

if numel(pts)==1
    % pts gives the known number of points in the point process.
    density = pts/Area;
elseif ismember(2,size(pts))
    % pts is a vector of points.
    npts = length(pts);
    density = npts/Area;
else
    error('pts must either be a 2-column point vector or the number of points in the point process')
end

end

