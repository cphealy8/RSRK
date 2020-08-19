PPName = 'Anisotropic Clusters - Perpendicular - Homogenous'; % metadata

ParentNum = round(npts/10);
ptsperclust = round(npts/ParentNum);
ChildNumMean = ptsperclust-1;
ChildNumSD = ptsperclust/10;
Angs = [15*pi/32 17*pi/32];

ChildNumOpns = [ChildNumMean ChildNumSD];

radius = 0.1;
ROpns = [0 radius];

pts = PoissonClusts(win,ParentNum,ChildNumOpns,ROpns,'ChildNumProbs',...
    'normal','AngProbs','uniform','AngOpns',Angs);