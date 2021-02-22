function [im] = hexGrid(apothem,imwidth,imheight)
%HEXGRID Generate logical image of hexagonal grid.
%   im = HEXGRID(apothem,imwidth,imheight) generates an image of size
%   imwidth-by-imheight of a hexagonal grid where the size of the hexagons
%   is determined by the apothem argument. 
%
%   SEE ALSO POLY2MASK and PATCH.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%%

buff = 10;
tempwidth = imwidth+2*buff;
tempheight = imheight+2*buff;

% Define x coordinate of hexagon verts
xhex = [apothem 2*apothem 2*apothem apothem 0 0]; 
% Define y coordinate of hexagon verts
yhex = [0 apothem/sqrt(3) sqrt(3)*apothem 4*apothem/sqrt(3) sqrt(3)*apothem apothem/sqrt(3)];

% Generage blank image
tempim = false(tempwidth,tempheight);

% Determine the number of hexagons needed for each dimension
hexXmax = round(tempheight/(2*apothem));
hexYmax = round(tempwidth/(2*apothem*sqrt(3)))+1;

% Define points for the lower left corner of each hexagon. Ignore the
% offset hexagons for now. 
xpts = 2*apothem*(0:1:hexXmax); % x-coordinate
ypts = 2*apothem*sqrt(3)*(0:1:hexYmax); % y-coordinate
[xgrid,ygrid] = meshgrid(xpts,ypts);

% Compute the shift needed for each hexagon and add the offset hexagons by
% shifting the points given in xgrid and concatenating all the coordinates
% together.
xshift = [xgrid(:) ;xgrid(:)+apothem];
yshift = [ygrid(:) ;ygrid(:)+sqrt(3)*apothem];

% Compute hexagons. Generate 1 by 1 and compile together.
for i = 1:length(xshift)
    bw = poly2mask(xhex+xshift(i),yhex+yshift(i),tempwidth,tempheight);
    bw = bwmorph(bw,'remove');
    tempim = logical(tempim+bw);
end

tempim = bwmorph(tempim,'skel','inf'); % Shrink to single pixel skeleton
tempim = imdilate(tempim,strel('disk',1)); % Dilate to ensure separation.
% Crop to requested dimensions.
im = tempim(buff:(buff+imwidth-1),buff:(buff+imheight-1));
end

