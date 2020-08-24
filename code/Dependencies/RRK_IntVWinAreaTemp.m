load('..\..\data\Verification Tests\Random Nonhomogenous Parallel.mat')

[OptimizationMetric,AveAOC,AreaFraction] = RRK_IntVWinArea(L,r,win,FPosition);

function [OptimizationMetric,AveAOC,AreaFraction] = RRK_IntVWinArea(L,r,win,FPosition)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
winWidth = win(2)-win(1);
winHeight = win(4)-win(3);

numstates = length(L);
OptimizationMetric = zeros(1,numstates);
AveAOC = zeros(1,numstates);
AreaFraction = zeros(1,numstates);
% For each frame state
for n=1:numstates
    curL = L{n};
    curF = FPosition{n};
    
    FWidth = curF(1)*winWidth;
    if length(curF)==1
        AOC = trapz(r,abs(curL));
    else
        AOC = trapz(curF,trapz(r,abs(curL)));
    end
    
    FArea = FWidth*winHeight;
    AveAOC(n) = mean(AOC);
    
    AreaFraction(n) = FArea/(winWidth*winHeight);
    
    OptimizationMetric(n) = AreaFraction(n)*AveAOC(n);
end

end

