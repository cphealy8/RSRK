% Bivariate PP
PPName = 'Random Random - 20 to 80 - Homogenous'; % metadata

nptsA = round(npts*0.2);
nptsB = npts-nptsA;

ptsA = PoissonPP(win,nptsA);
ptsB = PoissonPP(win,nptsB);