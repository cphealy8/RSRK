PPName = 'Mixed - Nonhomogenous - Perpendicular'; % metadata

NumClusts = npts/10;
PkgDens = 0.5;
InhDist = sqrt(4*5*PkgDens/(pi*NumClusts));

ptsperclust = round(npts/NumClusts);
childmean = ptsperclust-1;
childsd = ptsperclust/10;

ClustCenters = InhibitionPP(win,PkgDens,InhDist);

pts = PoissonClusts(win,ClustCenters,[childmean childsd],[0 0.07],'ChildNumProbs','normal');

IntensityMap_TriWave_perpendicular
pts = ThinByIntensity(IMap,win,pts);