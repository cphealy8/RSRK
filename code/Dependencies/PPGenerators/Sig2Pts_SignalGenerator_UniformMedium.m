% Self Signal Gen
% Use this to convert a point process into a signal consistently between
% tests.

imRez = 100;
sigRadius = 0.23;
sigSD = sigRadius/5;
sigpts = InhibitionPP(win,0.5,2*sigRadius);

sigKern = double(CircKern(sigRadius*imRez));
sigKern = sigKern./max(sigKern(:));
[Signal] = pts2signal(sigpts,win,imRez,sigKern,'Normalize','true');

