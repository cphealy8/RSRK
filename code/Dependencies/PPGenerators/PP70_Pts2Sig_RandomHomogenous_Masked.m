% Bivariate PP
PPName = 'Pts2Sig - Random Homogenous - Masked Homogenous'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;

HomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% SelfSignalGenerator
% % 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')