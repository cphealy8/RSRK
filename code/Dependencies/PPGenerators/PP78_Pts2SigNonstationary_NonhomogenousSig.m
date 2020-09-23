% Bivariate PP
PPName = 'Pts2Sig - Nonstationary - Nonhomogenous Signal'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Nonstationarity Map
IntensityMap_TriWave_parallel

% Generate Points
% Positively Associated
pts1 = PoissonPP(win,npts*11)*imRez;
pts1 = ThinByIntensity(Signal,win*imRez,pts1);
pts1 = ThinByIntensity(IMap,win*imRez,pts1);
pts1(1001:end,:) = [];


% Negatively Associated
pts2 = PoissonPP(win,npts*3)*imRez;
pts2 = ThinByIntensity(1-Signal,win*imRez,pts2);
pts2 = ThinByIntensity(1-IMap,win*imRez,pts2);
pts2(1001:end,:) = [];

%combine
pts = [pts1; pts2];

%% Nonhomogeneity
% pts = ThinByIntensity(IMap,win*imRez,pts);
Signal = Signal.*IMap(1:win(4).*imRez,1:win(2).*imRez);

imagesc(Signal)
hold on
plot(pts(:,1),pts(:,2),'.r')
