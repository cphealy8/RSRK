clc; clear; close all;

Win = [0 1 0 1];
PkgDens = 0.5;
InhDist = 0.05;
IntensityMap = repmat(linspace(0,1,100),[100 1]);

% pts=InhibitionPP(Win,PkgDens,InhDist,'MaxReps',50);
pts=InhibitionPP(Win,PkgDens,InhDist,'MaxReps',50,'IntensityMap',IntensityMap);

plot(pts(:,1),pts(:,2),'.r','MarkerSize',15)
axis equal
axis(Win)