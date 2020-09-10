clc; clear;
pts = 100*[1 2 3 4; 0.2 0.4 0.6 0.8]';
imRes = [5 1]*100;
% 
% im = zeros(imRes);
% 
% [pixID] = pts2pix(pts,imRes);
% im(pixID) = 1;

im = pts2Imap(pts,imRes);
imshow(im)
hold on
plot(pts(:,1),pts(:,2),'.r')
axis xy

% sig2pts(im
