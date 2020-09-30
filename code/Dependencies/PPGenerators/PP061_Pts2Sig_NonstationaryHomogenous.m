% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Nonstationarity Map
IntensityMap_TriWave_parallel

% Generate Points
% Positively Associated
pts1 = PoissonPP(win,npts*6)*imRez;
pts1 = ThinByIntensity(Signal,win*imRez,pts1);
pts1 = ThinByIntensity(IMap,win*imRez,pts1);
pts1(501:end,:) = [];


% Negatively Associated
pts2 = PoissonPP(win,npts*5)*imRez;
pts2 = ThinByIntensity(1-Signal,win*imRez,pts2,4);
pts2 = ThinByIntensity(1-IMap,win*imRez,pts2,4);
pts2(501:end,:) = [];

%combine
pts = [pts1; pts2];
% 
% imagesc(Signal)
% hold on
% 
% plot(pts(:,1),pts(:,2),'.r')
% plot(pts1(:,1),pts1(:,2),'.r')
% plot(pts2(:,1),pts2(:,2),'.g')