PPName = 'NonStationary - Parallel - Nonhomogenous - Parallel S'; % metadata

IntensityMap_TriWave_parallel

PP02_AggregatedSmallClustersHomogenous
ptsA = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsB = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Parallel - Nonhomogenous - Parallel S'; % metadata

pts = [ptsA;ptsB];

IntensityMap_TriWave_parallel_small
pts = ThinByIntensity(IMap,win,pts);