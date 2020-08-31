PPName = 'Regular - Small Spacing - Nonhomogenous - Parallel - Small'; % metadata

InhDist = 0.025;
PkgDens = 0.0982;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_parallel_small
pts = ThinByIntensity(IMap,win,pts);