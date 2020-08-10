clc; clear; close all;
% Generate aggregated point pattern using poisson cluster processes.
NumParents = 20;
win = [0 1 0 1];
opnOffspring = [1 2 3 4];
pOffspring = [0.4 0.3 0.2 0.1];

drOptions = linspace(0.01,0.05,20);
drProbs = normpdf(1:length(drOptions),0,5);

thetaOptions = linspace(0,2*pi,33);
thetaOptions(end) = [];
thetaProbs = ones(1,length(thetaOptions));



% Input processing

drProbs = drProbs./sum(drProbs);
thetaProbs = thetaProbs./sum(thetaProbs); 

PoissonClusts(win,NumParents,opnOffspring,drOptions)

% preview
hold on
plot(ParentPts(:,1),ParentPts(:,2),'.r')
plot(ChildPts(:,1),ChildPts(:,2),'.b')
axis equal
axis(win)


    
    