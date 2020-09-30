% Self Signal Gen
% Use this to convert a point process into a signal consistently between
% tests.

imRez = 100;
sigRadius = 0.5;
sigSD = sigRadius/5;
sigpts = InhibitionPP(win,0.5,sigRadius/1.2);

sigKern = fspecial('gaussian',sigRadius*imRez,sigSD*imRez);
sigKern = sigKern./max(sigKern(:));
[Signal] = pts2signal(sigpts,win,imRez,sigKern,'Normalize','true');

