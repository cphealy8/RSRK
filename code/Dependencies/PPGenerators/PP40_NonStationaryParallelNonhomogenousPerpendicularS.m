PPName = 'NonStationary - Parallel - Nonhomogenous - Perpendicular S'; % metadata

IntensityMap_TriWave_parallel

PP02_AggregatedSmallClustersHomogenous
ptsA = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsB = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Parallel - Nonhomogenous - Perpendicular S'; % metadata

pts = [ptsA;ptsB];

IntensityMap_TriWave_perpendicular_small
pts = ThinByIntensity(IMap,win,pts);