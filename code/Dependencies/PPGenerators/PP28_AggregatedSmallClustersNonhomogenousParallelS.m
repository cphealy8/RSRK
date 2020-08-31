PPName = 'Aggregated - Small Clusters - Nonhomogenous - Parallel - Small'; % metadata

ParentNum = round(npts/10);
ptsperclust = round(npts/ParentNum);
ChildNumMean = ptsperclust-1;
ChildNumSD = ptsperclust/10;

ChildNumOpns = [ChildNumMean ChildNumSD];

radius = 0.1;
ROpns = [0 radius];

pts = PoissonClusts(win,ParentNum,ChildNumOpns,ROpns,'ChildNumProbs','normal');
IntensityMap_TriWave_parallel_small
pts = ThinByIntensity(IMap,win,pts);