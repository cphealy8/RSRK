% Bivariate PP
PPName = 'Pts2Sig - Nonstationary - Nonhomogenous PP'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Nonstationarity Map
IntensityMap_TriWave_parallel

% Generate Nonstationary Points
PP61_Pts2Sig_NonstationaryHomogenous

%% Nonhomogeneity
pts = ThinByIntensity(IMap,win*imRez,pts);
% Signal = Signal.*IMap(1:win(4).*imRez,1:win(2).*imRez);

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')
% plot(pts1(:,1),pts1(:,2),'.r')
% plot(pts2(:,1),pts2(:,2),'.g')