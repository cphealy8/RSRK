clc; clear; close all;
% Generate aggregated point pattern using poisson cluster processes.
NumParents = 20;
win = [0 1 0 1];
IntensityMap = repmat(linspace(1,0,100),[100 1]);

ChildNumProbs = 'uniform';
ChildNumOpns = [3 10];

rOpns = [0 0.05];
rProbs = [0.1 0.2 0.3 0.4];

% Input processing 

[Pts,ParentPts,ChildPts] = PoissonClusts(win,NumParents,ChildNumOpns,rOpns);

% preview
hold on
plot(ParentPts(:,1),ParentPts(:,2),'.r')
plot(ChildPts(:,1),ChildPts(:,2),'.b')

axis equal
axis(win)


% % ThinByIntensity
[thinpts] = ThinByIntensity(IntensityMap,win,Pts);
plot(thinpts(:,1),thinpts(:,2),'og')

%%
pts = PoissonClusts(win,20,[5 10],[0 0.05]);
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)

%%
pts = PoissonClusts(win,20,[5 1],[0 0.05],'ChildNumProbs','normal');
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)
%%
pts = PoissonClusts(win,20,5,[0 0.05]);
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)

%%
pts = PoissonClusts(win,3,50,0.05,'RProbs','exponential');
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)


%%
pts = PoissonClusts(win,10,10,[0 0.08],'AngProbs','uniform','AngOpns',[0 pi/8]);
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)

%%
pts = PoissonClusts(win,20,5,[0 0.05],'IntensityMap',IntensityMap);
plot(pts(:,1),pts(:,2),'.b','MarkerSize',15);
axis equal
axis(win)
