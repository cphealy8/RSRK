clc; clear; close all;
% Generate aggregated point pattern using poisson cluster processes.
NumParents = 20;
win = [0 1 0 1];

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


    
    