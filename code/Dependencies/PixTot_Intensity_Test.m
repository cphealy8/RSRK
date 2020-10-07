im = fspecial('gaussian',20,5);
pts = rand(10,2)*20;
imagesc(im); hold on; plot(pts(:,1),pts(:,2),'.r');
r = [1 2 3];
mask = ones(size(im));

[K1, npts, pixTot1, A] = RKSignal2Pts(0.1*im,pts,r,mask);

[K2, npts, pixTot2, A] = RKSignal2Pts(im,pts,r,mask);

[K3, npts, pixTot3, A] = RKSignal2Pts(10*im,pts,r,mask);

[pixTot1; pixTot2; pixTot3]
[K1;K2;K3]