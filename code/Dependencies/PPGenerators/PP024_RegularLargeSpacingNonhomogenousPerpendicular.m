PPName = 'Regular - Large Spacing - Nonhomogenous - Perpendicular'; % metadata

InhDist = 0.05;
PkgDens = 0.3927;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_perpendicular
pts = ThinByIntensity(IMap,win,pts);
