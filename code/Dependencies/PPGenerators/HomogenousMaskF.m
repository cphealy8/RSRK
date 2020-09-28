function [Mask] = HomogenousMaskF(win,imRez,maskRadius,nctrs)
%HOMOGENOUSMASKF Summary of this function goes here
%   Detailed explanation goes here

maskCtrs = PoissonPP(win,nctrs);

maskKern = CircKern(maskRadius*imRez);

Mask = pts2signal(maskCtrs,win,imRez,maskKern,'Normalize','false');
Mask = logical(Mask);

end

