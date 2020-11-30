PPName = 'NonStationary - Parallel - Homogenous'; % metadata

IntensityMap_TriWave_parallel

PP002_AggregatedSmallClustersHomogenous
ptsU = ThinByIntensity(IMap,win,pts);

PP005_RegularLargeSpacingHomogenous
ptsV = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Parallel - Homogenous'; % metadata

pts = [ptsU;ptsV];