PPName = 'Regular - Small Spacing - Nonhomogenous - Perpendicular'; % metadata

InhDist = 0.025;
PkgDens = 0.0982;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_perpendicular
pts = ThinByIntensity(IMap,win,pts);