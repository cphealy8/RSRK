PPName = 'NonStationary - Perpendicular - Homogenous'; % metadata

IntensityMap_TriWave_perpendicular

PP02_AggregatedSmallClustersHomogenous
ptsU = ThinByIntensity(IMap,win,pts);

PP05_RegularLargeSpacingHomogenous
ptsV = ThinByIntensity(1-IMap,win,pts);

clear pts
PPName = 'NonStationary - Perpendicular - Homogenous'; % metadata

pts = [ptsU;ptsV];