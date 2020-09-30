% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous - Uniform Medium'; % metadata

% Signal
Sig2Pts_SignalGenerator_UniformMedium

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;

% NonstationaryPointsGen
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')