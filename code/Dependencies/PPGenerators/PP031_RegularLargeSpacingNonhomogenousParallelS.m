PPName = 'Regular - Large Spacing - Nonhomogenous - Parallel - Small'; % metadata

InhDist = 0.05;
PkgDens = 0.3927;

pts = InhibitionPP(win,PkgDens,InhDist);

IntensityMap_TriWave_parallel_small
pts = ThinByIntensity(IMap,win,pts);
