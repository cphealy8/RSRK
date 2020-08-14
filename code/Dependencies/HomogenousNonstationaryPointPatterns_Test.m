clc; clear; close all;

% Overlap two processes with different parameters with inversely related
% intensity functions. 
win = [0 4 0 1];
Area = (win(2)-win(1))*(win(4)-win(3));

IntensityMap = repmat(linspace(0,1,win(2)*100+1),[101 1]);


%% Aggregated point processes 
ntot = 400;
Radius = [0 0.1];

% P1 = [rangeRand([1000 1],win(1),win(2)) rangeRand([1000 1],win(3),win(4))];
% P1 = ThinByIntensity(IntensityMap,win,P1);
% P2 = [rangeRand([1000 1],win(1),win(2)) rangeRand([1000 1],win(3),win(4))];
% P2 = ThinByIntensity(1-IntensityMap,win,P2);

% Define parents and children to ensure consistent density between both
P1Parents = 40;
P1Children = ntot/P1Parents - 1;
P1Radius = [0 0.1];
P1 = PoissonClusts(win,P1Parents,P1Children,P1Radius,'IntensityMap',IntensityMap);

P2Parents = 80;
P2Children = ntot/P2Parents - 1;
P2Radius = [0 .07];
P2 = PoissonClusts(win,P2Parents,P2Children,P2Radius,'IntensityMap',1-IntensityMap);

figure
plot(P1(:,1),P1(:,2),'.r')
hold on
plot(P2(:,1),P2(:,2),'.b')
axis image
axis(win)

%% Aggregated to Regular
ntot = 400;

% Aggregate Pattern
P1Parents = 40;
P1Children = ntot/P1Parents - 1;
P1Radius = [0 0.05];
P1 = PoissonClusts(win,P1Parents,P1Children,P1Radius,'IntensityMap',IntensityMap);

% Uniform Pattern
PkgDens = 0.5;
InhDist = sqrt(4*Area*PkgDens/(pi*ntot));
P2 = InhibitionPP(win,0.55,InhDist,'IntensityMap',1-IntensityMap);


figure
plot(P1(:,1),P1(:,2),'.r')
hold on
plot(P2(:,1),P2(:,2),'.b')
axis image
axis(win)