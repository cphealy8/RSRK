function [CatVar] = Cont2Cat(ContVar,Bounds)
%CONT2CAT Convert a continuous variable to discrete categories. 
%   [CatVar] = CONT2CAT(ContVar,Bounds) converts continuous data (ContVar)
%   to categories whose boundaries are defined by the input vector Bounds. 
%
%   [CatVar] = CONT2CAT(ContVar,[1 3]) converts the continuous data
%   (ContVar) into 1 of 3 categories. Less than 1, between 1 and 3, and
%   greater than 3. 
%
%   SEE ALSO CATCOLORMAP.
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

Bounds = sort(Bounds);

% Set the number of categories.
ncat = length(Bounds)+1;
Cats = 1:ncat;
CatVar = zeros(size(ContVar));

% Handle the upper and lower boundaries
CatVar(ContVar<Bounds(1)) = Cats(1);
CatVar(ContVar>=Bounds(end)) = Cats(end);

% Handle the internal cases
for k = 2:(ncat-1)
    upperLim = Bounds(k);
    lowerLim = Bounds(k-1);
    
    CatVar(ContVar >= lowerLim & ContVar < upperLim) = Cats(k);
end
end