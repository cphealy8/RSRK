PPName = 'NonStationary - Parallel - Nonhomogenous - Perpendicular'; % metadata

IntensityMap_TriWave_parallel

PP02_AggregatedSmallClustersHomogenous
ptsU = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsV = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Parallel - Nonhomogenous - Parallel'; % metadata

pts = [ptsU;ptsV];

IntensityMap_TriWave_perpendicular
pts = ThinByIntensity(IMap,win,pts);