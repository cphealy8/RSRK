% Bivariate PP
PP01_RandomHomogenous % load baseline PP

PPName = 'Self - Random Homogenous - Masked Nonhomogenous'; % metadata

% pts = PoissonPP(win,npts);
SelfSignalGenerator

NonHomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;
