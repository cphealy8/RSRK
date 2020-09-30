% Bivariate PP
PPName = 'Pos. Assoc.- 50 to 50 - Homogenous'; % metadata

% A Points
nptsA = round(npts*0.5);
InhDist = 0.08;
PkgDens = 0.45;
ptsA = InhibitionPP(win,PkgDens,InhDist);

% B Points
nptsB = npts-nptsA;
ptsBperclust = round(nptsB/nptsA);
[~,~,ptsB] = PoissonClusts(win,ptsA,ptsBperclust,[0 0.04]);