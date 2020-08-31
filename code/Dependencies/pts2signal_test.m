clc;clear;close all;

pts = [2 1].*rand(100,2);
win = [0 2 0 1];
imRes = 100;
sigKern = fspecial('gaussian',30,sqrt(30));



sigim = pts2signal(pts,win,imRes,sigKern);

figure
subplot(3,1,1)
plot(pts(:,1),pts(:,2),'.r')
axis image
subplot(3,1,2)
imagesc(sigKern);
axis image
subplot(3,1,3);
imagesc(sigim)
axis image
