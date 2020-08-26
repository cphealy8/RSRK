PPName = 'NonStationary - Parallel - Homogenous'; % metadata

IntensityMap_TriWave_parallel

PP02_AggregatedSmallClustersHomogenous
ptsA = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsB = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Parallel - Homogenous'; % metadata

pts = [ptsA;ptsB];