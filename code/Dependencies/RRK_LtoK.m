clc; clear; close all;
filename = '..\..\data\Verification Tests\PP18 - Mixed - Nonhomogenous - Parallel.mat';
load(filename)

for n=1:length(L)
    curL = L{n};
    [nr,nw,nreps] = size(curL);
    rmat = repmat(r',1,nw,nreps);
    curL = curL+rmat;
    K{n} = pi*(curL.^2);
end

save(filename,'K','L','npts','win','r','PPName','FPosition');