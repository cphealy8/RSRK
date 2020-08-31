PPName = 'Regular - Large Spacing - Nonhomogenous - Perpendicular - Small'; % metadata

InhDist = 0.05;
PkgDens = 0.3927;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_perpendicular_small
pts = ThinByIntensity(IMap,win,pts);
