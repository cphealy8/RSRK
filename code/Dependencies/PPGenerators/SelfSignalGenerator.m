% Self Signal Gen
% Use this to convert a point process into a signal consistently between
% tests.

imRez = 100;
sigRadius = 0.1;
sigSD = sigRadius/4;

sigKern = fspecial('gaussian',sigRadius*imRez,sigSD*imRez);
sigKern = sigKern./max(sigKern(:));

[Signal,pts] = pts2signal(pts,win,imRez,sigKern,'Normalize','false');