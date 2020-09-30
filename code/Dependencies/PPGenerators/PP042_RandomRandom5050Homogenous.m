% Bivariate PP
PPName = 'Random Random - 50 to 50 - Homogenous'; % metadata

nptsA = round(npts*0.5);
nptsB = npts-nptsA;

ptsA = PoissonPP(win,nptsA);
ptsB = PoissonPP(win,nptsB);