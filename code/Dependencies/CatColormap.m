function [cmap] = CatColormap(Categories,Colors,varargin)
%CATCOLORMAP Creates a categorical colormap. 
%   [cmap] = CATCOLORMAP(Categories,Colors) where Categories is a vector of
%   discrete numerical categories with length n, and Colors is a nx3
%   matrix of color specifications returns the discrete colormap (cmap). 
%
%   [cmap] = CATCOLORMAP(Categories,Colors,Ax) applies the categorical
%   colormap to the axis specified by the axis handle AX. 
%
%   SEE ALSO CONT2CAT.
%
%   Author: Connor P. Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah
nCategories = length(Categories);
[ColorRows, ColorCols]= size(Colors);
if ColorCols~=3 && ColorRows==3
    Colors = Colors';
    nColors = ColorCols;
elseif ColorCols==3 && ColorRows~=3
    nColors = ColorRows;
elseif ColorCols~=3 && ColorRows~=3
    error('Colors must be a 3-column matrix');
end


if nCategories~= nColors
    error('A color must be specified for each category');
end

cmap = Colors;

if nargin==3
    ax = varargin{1};
    colormap(ax,cmap);
    caxis(ax,[Categories(1)-1 Categories(end)])
end

end


