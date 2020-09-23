% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous - Masked Homogenous'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Nonstationarity Map
IntensityMap_TriWave_parallel

% Generate Nonstationary Points
PP61_Pts2Sig_NonstationaryHomogenous

HomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')
