% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;
% SelfSignalGenerator
% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')