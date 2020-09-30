% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous - Striped Perpendicular'; % metadata

% Signal
IntensityMap_TriWave_perpendicular_small
Signal = IMap;
imRez = 100;
% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')