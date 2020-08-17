win = [0 5 0 1];
npts = 1000;
nFrames = 9;
fOverlap = 0.5;

r = linspace(0,1,21);
r(1) = [];

pts = PoissonPP(win,npts);

[K,L] = RRK(pts,win,r,nFrames,fOverlap,'on');