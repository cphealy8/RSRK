% Bivariate PP
PP01_RandomHomogenous % load baseline PP

PPName = 'Self - Random Homogenous - Masked Homogenous'; % metadata

% pts = PoissonPP(win,npts);
SelfSignalGenerator

HomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')