PPName = 'Regular - Large Spacing - Nonhomogenous - Parallel'; % metadata

InhDist = 0.05;
PkgDens = 0.3927;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_parallel
pts = ThinByIntensity(IMap,win,pts);
