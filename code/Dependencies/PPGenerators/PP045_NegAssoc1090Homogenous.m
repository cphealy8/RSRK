% Bivariate PP
PPName = 'Neg. Assoc.- 10 to 90 - Homogenous'; % metadata

% A Points
nptsA = round(npts*0.1);
InhDist = 0.17;
PkgDens = 0.45;
ptsA = InhibitionPP(win,PkgDens,InhDist);

imRes = 100;
clustRad = 0.08;
% sigKern = fspecial('gaussian',clustRad*imRes,0.05*imRes);
sigKern = CircKern(clustRad*imRes);
sig = pts2signal(ptsA,win,imRes,sigKern);
sig(sig>0)= 1;

ptsBase =PoissonPP(win,npts*2);
ptsB = ThinByIntensity(1-sig,win,ptsBase);

ptsB((npts-nptsA+1):end,:) = [];

% close all;
% % figure
% % imshow(sig); hold on; plot(imRes*ptsA(:,1),imRes*ptsA(:,2),'dr');
% % plot(imRes*ptsB(:,1),imRes*ptsB(:,2),'.b')
% % axis xy
% figure
% plot(ptsA(:,1),ptsA(:,2),'dr')
% hold on
% plot(ptsB(:,1),ptsB(:,2),'.b')
% axis equal
% axis tight


