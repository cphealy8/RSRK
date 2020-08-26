PPName = 'NonStationary - Perpendicular - Homogenous'; % metadata

IntensityMap_TriWave_perpendicular

PP02_AggregatedSmallClustersHomogenous
ptsA = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsB = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Perpendicular - Homogenous'; % metadata

pts = [ptsA;ptsB];