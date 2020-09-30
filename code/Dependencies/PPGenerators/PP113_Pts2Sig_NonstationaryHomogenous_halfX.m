% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous - S halfX'; % metadata

% Signal
Sig2Pts_SignalGenerator

Signal = Signal.*0.5;
npts = 1000;

NonstationaryPointsGen
% 
% imagesc(Signal)
% hold on
% 
% plot(pts(:,1),pts(:,2),'.r')
% plot(pts1(:,1),pts1(:,2),'.r')
% plot(pts2(:,1),pts2(:,2),'.g')