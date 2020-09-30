% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous - Uniform Large'; % metadata

% Signal
Sig2Pts_SignalGenerator_UniformLarge

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;

NonstationaryPointsGen
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')