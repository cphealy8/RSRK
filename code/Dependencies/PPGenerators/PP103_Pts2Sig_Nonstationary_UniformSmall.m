% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous - Uniform Small'; % metadata

% Signal
Sig2Pts_SignalGenerator_UniformSmall

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;

NonstationaryPointsGen
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')