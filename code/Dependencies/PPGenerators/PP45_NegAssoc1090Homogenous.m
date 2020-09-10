% Bivariate PP
PPName = 'Neg. Assoc.- 10 to 90 - Homogenous'; % metadata

% A Points
nptsA = round(npts*0.1);
InhDist = 0.17;
PkgDens = 0.45;
ptsA = InhibitionPP(win,PkgDens,InhDist);

sigKern = fspecial('gaussian',30,5);
sig = pts2signal(ptsA,win,1000,sigKern);
sig = sig/0.1;
sig(sig>1)= 1;

ptsBase =PoissonPP(win,npts);
ptsB = ThinByIntensity(1-sig,win,ptsBase);
% B Points
% nptsB = npts-nptsA;
% ptsBperclust = round(nptsB/nptsA);
% clustRad = 0.1;
% [~,~,ptsB] = PoissonClusts(win,ptsA,ptsBperclust,[0.07 0.08]);