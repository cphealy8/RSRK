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

% Signals
mask1 = pts2signal(sigpts,win,imRez,kernMask,'Normalize','false');
mask1 = mask1>0;

mask2 = ones(size(mask1));
Signal = 1-mask1;

%% Nonstationarity
% pts = PoissonPP(win,npts*1.5)*imRez;
% 
% pts = CropPts2Mask(pts,mask1);
% pts((npts+1):end,:)=[];
[pts] = RandPPMask(npts,mask1);


% imshow(mask1); hold on; plot(pts(:,1),pts(:,2),'.r')