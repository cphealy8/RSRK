% Bivariate PP
PPName = 'Pts2Sig - Random Nonhomogenous - Masked Nonhomogenous'; % metadata

% Signal
Sig2Pts_SignalGenerator

% Generate Points
[pts,density] = PoissonPP(win,npts);
pts = pts*imRez;
IntensityMap_TriWave_parallel
% pts = ThinByIntensity(IMap,win*imRez,pts);

Signal = Signal.*IMap(1:win(4).*imRez,1:win(2).*imRez);

% Masking
NonHomogenousMask
pts = CropPts2Mask(pts,Mask);
Signal = Signal.*Mask;

% imagesc(Signal)
% hold on
% plot(pts(:,1),pts(:,2),'.r')