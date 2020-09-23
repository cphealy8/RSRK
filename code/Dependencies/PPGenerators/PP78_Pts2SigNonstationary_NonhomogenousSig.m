% Bivariate PP
PPName = 'Pts2Sig - Nonstationary - Nonhomogenous Signal'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Nonstationarity Map
IntensityMap_TriWave_parallel

% Generate Nonstationary Points
PP61_Pts2Sig_NonstationaryHomogenous

%combine
pts = [pts1; pts2];

%% Nonhomogeneity
% pts = ThinByIntensity(IMap,win*imRez,pts);
Signal = Signal.*IMap(1:win(4).*imRez,1:win(2).*imRez);

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')
