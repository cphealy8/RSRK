function [fH] = RRK_TTest_Plot(r,FPosition,T,pts,PPName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fH = figure('Position',[50 50 350 50*length(T)]);
[ha,pos] = tight_subplot(length(T)+1, 1, 0, 0.1, 0.15);

axes(ha(1))
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5);
title(PPName)

for k=1:length(T)
x = FPosition{k};
Tk = T{k};
if length(x)>1
    diffx = x(2)-x(1);
    xplot = [x(1)-diffx x];
else
    xplot = [0 x];
end

rplot = [0 r];


Lplot = [Tk,zeros(size(Tk,1),1); zeros(1,size(Tk,2)+1)];

% Lplot = Lmean;
axes(ha(k+1));
dr = log10(r(2))-log10(r(1));


pH = pcolor(xplot,rplot,Lplot);
% shading faceted
set(gca,'YScale','log')
YTicks = round(r(1:2:end),2);
ylim([r(1) 10^(log10(r(end))+dr)])

set(gca,'YTick',YTicks)
YTickLabels = cellstr(num2str(round(log10(YTicks(:)),1), '10^%0.1f'));
set(gca,'YTickLabel',YTickLabels);

%%

caxis([0 1])
% 4-level
% colInts = [0 0.95 0.95000001 0.99 0.9900001 0.999 0.9990001 1];
% colNames = {'#ffffff','#ffffff','#ffff33','#ffff33','#ff7f00','#ff7f00','#e41a1c','#e41a1c'};

% 2 - level
colInts = [0 0.99 0.9900001  1];
colNames = {'#ffffff','#ffffff','#e41a1c','#e41a1c'};

map = customcolormap(colInts,colNames);
colormap(map)
% colorbar
end

end

