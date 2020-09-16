% Self Signal Gen
% Use this to convert a point process into a signal consistently between
% tests.

imRez = 100;
maskCtrs = PoissonPP(win,50);

IntensityMap_TriWave_parallel
maskCtrs = ThinByIntensity(IMap,win,maskCtrs);

maskRadius = 0.2;

maskKern = CircKern(maskRadius*imRez);

Mask = pts2signal(maskCtrs,win,imRez,maskKern,'Normalize','false');
Mask = logical(Mask);