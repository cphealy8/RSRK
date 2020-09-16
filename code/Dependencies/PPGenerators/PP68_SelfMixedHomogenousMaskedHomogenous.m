% Bivariate PP
PP06_MixedHomogenous % load baseline PP

PPName = 'Self Mixed - Homogenous - Masked Homogenous'; % metadata

% pts = PoissonPP(win,npts);
SelfSignalGenerator

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')

HomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;