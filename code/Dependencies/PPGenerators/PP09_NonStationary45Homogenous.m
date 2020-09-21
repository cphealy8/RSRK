PPName = 'NonStationary - 45 - Homogenous'; % metadata

IntensityMap_TriWave_45
IMap = IMap;
PP02_AggregatedSmallClustersHomogenous
ptsU = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsV = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - 45 - Homogenous'; % metadata

pts = [ptsU;ptsV];