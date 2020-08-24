clc; clear; close all;

load('..\..\data\Verification Tests\Random Homogenous.mat')
fntsz= 10;
%%
k = 9;
Lmean = mean(L{k},3);
x = FPosition{k};
xplot = [0 x];
rplot = [0 r];
f2 = figure('Units','points','Position',[300 300 400 150]);
Lplot = [Lmean,zeros(size(Lmean,1),1); zeros(1,size(Lmean,2)+1)];

p1 = pcolor(xplot,rplot,Lplot);
xlabel('Window Position (% of Total Length)','FontSize',fntsz)
ylabel('Scale r (a.u.)','FontSize',fntsz)
zlabel('K(r)');


ax = gca;
ax = TightAxes(ax);
% set(ax,'YScale','log')
set(ax,'FontSize',fntsz)
c1 = colorbar;
% Set axis limits to 3 times the maximum standard deviation of the
% observations.
maxlim = max(max(std(L{k},0,3)));

caxis([-maxlim maxlim]);
% colormap inferno
% map = diverging_map(linspace(0,1,64),[0.23 0.299 0.754],[0.706 0.016 0.150]);
colInt = [5 33 67 146 209 247 253 244 214 178 103;...
          48 102 147 197 229 247 219 165 96 24 0;...
          97 172 195 222 240 247 199 130 77 43 31]';
map = myDivergingMap(colInt,10);
colormap(map)

figure
surf(x,r,Lmean)
zlim([-maxlim maxlim]);
colormap(map)
c2 = colorbar;
caxis([-maxlim maxlim]);

%%
clc; clear; close all;
load('..\..\data\Verification Tests\Mixed - Homogenous.mat')
[fH,pH] = RRK_Verification_Plot(r,FPosition,L);