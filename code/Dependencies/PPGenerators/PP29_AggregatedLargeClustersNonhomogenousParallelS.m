PPName = 'Aggregated - Large Clusters - Nonhomogenous - Parallel - Small'; % metadata

ParentNum = round(npts/100);
ptsperclust = round(npts/ParentNum);
ChildNumMean = ptsperclust-1;
ChildNumSD = ptsperclust/10;

ChildNumOpns = [ChildNumMean ChildNumSD];

radius = 0.3162;
ROpns = [0 radius];

pts = PoissonClusts(win,ParentNum,ChildNumOpns,ROpns,'ChildNumProbs','normal');
IntensityMap_TriWave_parallel_small
pts = ThinByIntensity(IMap,win,pts);
