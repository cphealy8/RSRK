PPName = 'NonStationary - 45 - Homogenous'; % metadata

IntensityMap_TriWave_45
IMap = IMap;
PP02_AggregatedSmallClustersHomogenous
ptsA = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsB = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - 45 - Homogenous'; % metadata

pts = [ptsA;ptsB];