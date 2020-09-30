% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous - Gaussian Small'; % metadata

% Signal
Sig2Pts_SignalGenerator_GaussSmall

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;

NonstationaryPointsGen
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')