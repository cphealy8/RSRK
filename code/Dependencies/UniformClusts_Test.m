clc; clear; close all;
Win = [0 1 0 1];

% Generate Parent Pts
[ParentPts] = InhibitionPP(Win,0.55,0.1,'MaxReps',50);

% Generat ChildPts
[~,~,ChildPts] = PoissonClusts(Win,ParentPts,10,[0 0.03]);

%%
figure
plot(ParentPts(:,1),ParentPts(:,2),'.r','MarkerSize',15)
hold on
plot(ChildPts(:,1),ChildPts(:,2),'ob')
axis equal
axis(Win)
