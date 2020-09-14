% Bivariate PP
PPName = 'Random Random - 10 to 90 - Homogenous'; % metadata

nptsA = round(npts*0.2);
nptsB = npts-nptsA;

ptsA = PoissonPP(win,nptsA);
ptsB = PoissonPP(win,nptsB);