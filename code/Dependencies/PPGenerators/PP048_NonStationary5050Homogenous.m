% Bivariate PP
PPName = 'Nonstationary - 50 to 50 - Homogenous'; % metadata
IntensityMap_TriWave_parallel

PP44_PosAssoc5050Homogenous
% nptsA1 = round(npts*0.1/2);
% nptsB1 = (npts/2)-nptsA1;
ptsA1 = ThinByIntensity(IMap,win,ptsA);
ptsB1 = ThinByIntensity(IMap,win,ptsB);

PP46_NegAssoc5050Homogenous
ptsA2 = ThinByIntensity(1-IMap,win,ptsA);
ptsB2 = ThinByIntensity(1-IMap,win,ptsB);

ptsA = [ptsA1; ptsA2];
ptsB = [ptsB1; ptsB2];
