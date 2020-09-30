% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous - Masked Homogenous'; % metadata

% Pt Signal
imRez = 100;
sigRadius = 0.2;
sigSD = sigRadius/5;
sigpts = InhibitionPP(win,0.5,sigRadius*1.5);

sigKern = fspecial('gaussian',sigRadius*imRez,sigSD*imRez);
sigKern = sigKern./max(sigKern(:));
[ptSignal] = pts2signal(sigpts,win,imRez,sigKern,'Normalize','true');

% Mask 1
maskKern = CircKern(0.75*sigRadius*imRez);
[mask1] = pts2signal(sigpts,win,imRez,maskKern,'Normalize','false');


% Nonstationarity
IntensityMap_TriWave_parallel
IMap(end,:) = [];
IMap(:,end) = [];

% PP
% Positively Associated
pts1 = PoissonPP(win,npts*20)*imRez;
pts1 = ThinByIntensity(ptSignal,win*imRez,pts1);
pts1 = ThinByIntensity(IMap,win*imRez,pts1);
pts1 = CropPts2Mask(pts1,mask1);
pts1(501:end,:) = [];


% Negatively Associated
pts2 = PoissonPP(win,npts*5)*imRez;
pts2Signal = 
pts2 = ThinByIntensity(1-ptSignal,win*imRez,pts2,4);
pts2 = ThinByIntensity(1-IMap,win*imRez,pts2,4);
pts2 = CropPts2Mask(pts2,mask1);
pts2(501:end,:) = [];

%combine
pts = [pts1; pts2];



