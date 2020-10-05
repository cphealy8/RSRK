% Bivariate PP
PPName = 'Pts2Sig - Nonstationary Homogenous - Masked Homogenous'; % metadata

% Pt Signal
imRez = 100;
rmask = 0.1;
r1 = rmask/2;
r2 = sqrt((rmask^2)-(r1^2));
sigpts = InhibitionPP(win,0.5,rmask*1.5);

% Kernels
kernMask = CircKern(rmask*imRez);
kern1 = CircKern(r1*imRez);
kern2 = CircKern(r2*imRez);

% Signals
mask1 = pts2signal(sigpts,win,imRez,kernMask,'Normalize','false');
mask1 = mask1>0;

ptsig1 = pts2signal(sigpts,win,imRez,kern1,'Normalize','false');
ptsig2 = pts2signal(sigpts,win,imRez,kern2,'Normalize','false');
ptsig2 = mask1-ptsig2;

mask2 = ones(size(mask1));
Signal = double(1-mask1);

%% Nonstationarity
IntensityMap_TriWave_parallel
IMap(end,:) = [];
IMap(:,end) = [];

pts1 = PoissonPP(win,npts*10)*imRez;
pts1 = ThinByIntensity(ptsig1,win*imRez,pts1);
pts1 = ThinByIntensity(IMap,win*imRez,pts1,'reps',3);
pts1 = CropPts2Mask(pts1,mask1);
pts1(501:end,:) = [];

pts2 = PoissonPP(win,npts*13)*imRez;
pts2 = ThinByIntensity(ptsig2,win*imRez,pts2);
pts2 = ThinByIntensity(1-IMap,win*imRez,pts2);
pts2 = CropPts2Mask(pts2,mask1);
pts2(501:end,:) = [];

%combine
pts = [pts1; pts2];
% 
% plot(pts1(:,1),pts1(:,2),'.r',pts2(:,1),pts2(:,2),'.b')