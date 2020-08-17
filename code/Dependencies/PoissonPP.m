function [pts,density] = PoissonPP(win,npts)
%POISSONPP Generate a Poisson point process aka Random Point Process
%   [pts,density] = PoissonPP(win,npts) generates a point process in the 
%   window win=[xmin xmax ymin ymax] from npts randomly distributed points.
px = rangeRand([npts 1],win(1),win(2));
py = rangeRand([npts 1],win(3),win(4));
pts = [px py];

density = PPDensity(npts,win);
end

