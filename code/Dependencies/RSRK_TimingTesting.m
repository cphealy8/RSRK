clc;clear;close all;
onpts = [500 1000 1500];
okframes = [1 3 10];
orezX = [10 32 100];
onr = [5 10 15];
oSigLvls = 2./([10 32 100]+1);

%%
[X1,X2,X3,X4,X5]= ndgrid(onpts,okframes,orezX,onr,oSigLvls);
tbl = [X1(:) X2(:) X3(:) X4(:) X5(:)];
%%
runt= zeros(1,length(tbl));
for k = 1:length(tbl)
npts = tbl(k,1);
kFrames = tbl(k,2);
rezX = tbl(k,3);
nr = tbl(k,4);
SigLvl = tbl(k,5);

r = rezX*(1/nr:1/nr:1);
sz = rezX*[2 5];

fOverlap = 0.5;


Signal = ones(sz(1),sz(2));
mask = logical(Signal);
pts = RandPPMask(npts,logical(Signal));

tStart = tic;
[RK] = MovingRKSig(Signal,pts,r,mask,'Pts2Sig',kFrames,fOverlap,SigLvl,'X');
runt(k) = toc(tStart);
end

%%
dat = array2table([tbl runt'],'VariableNames',{'npts','kframes','rezx','nr','siglvl','runtime'});
dat.kframes = round(dat.kframes);
save('..\..\data\Timing\RunTimeTable.mat','dat')