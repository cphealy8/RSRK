function [pixID] = pts2pix(pts,imRes)
%PTS2PIX Convert point in image to the pixel ID nearest to that point. 
%   [pixID] = PT2PIX(pts,imRes) given point coordinates (pts) defined in an
%   image of resolution (imRes = [width height]) converts the points to
%   pixels. 
% 
%   SEE ALSO SUB2IND.

% Convert points into subscripts.
ptsubs = ceil(pts); 

% Convert point subscripts into indices. 
pixID = sub2ind(imRes,ptsubs(:,1),ptsubs(:,2));
end