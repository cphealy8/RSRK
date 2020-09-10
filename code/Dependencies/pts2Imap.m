function [im] = pts2Imap(pts,imRes)
%UNTITLED7 Convert points to index map with resolution imRes=[width height]
%   Detailed explanation goes here
im = zeros(imRes);

[pixID] = pts2pix(pts,imRes);
im(pixID) = 1;

im = im';
end

