% Bivariate PP
PP07_NonStationaryParallelHomogenous % load baseline PP

PPName = 'Self - Nonstationary Homogenous - Masked Homogenous'; % metadata

SelfSignalGenerator

HomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% 
% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')