% Bivariate PP
PP06_MixedHomogenous % load baseline PP

PPName = 'Self - Mixed Homogenous - Masked Nonhomogenous'; % metadata

% pts = PoissonPP(win,npts);
SelfSignalGenerator



NonHomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')