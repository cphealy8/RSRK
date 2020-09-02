function [fH,pH] = RRK_Verification_Plot(r,FPosition,L,pts,PPName,cLims)
%RRK_VERIFICATION_PLOT Plot RRK Verification Results
%   Detailed explanation goes here
%%


%Determine axes limits
LSD = RRK_SD(L);
LSDMat= cell2mat(LSD);
MaxSD = max(LSDMat(:));
LMean = RRK_Mean(L);
MeanMat = cell2mat(LMean);
MaxMean = max(MeanMat(:));
MinMean = min(MeanMat(:));

fH = figure('Position',[50 50 350 50*length(L)]);
[ha,pos] = tight_subplot(length(L)+1, 1, 0, 0.1, 0.15);

axes(ha(1))
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5);
title(PPName)
for k=1:length(L)
Lmean = mean(L{k},3,'omitnan');
x = FPosition{k};
if length(x)>1
    diffx = x(2)-x(1);
    xplot = [x(1)-diffx x];
else
    xplot = [0 x];
end

rplot = [0 r];
% xplot = [x];
% rplot = [r];

% f2 = figure('Units','points','Position',[300 300 400 150]);

dr = log10(r(2))-log10(r(1));

Lplot = [Lmean,zeros(size(Lmean,1),1); zeros(1,size(Lmean,2)+1)];

% if strcat(cLims,'pval')
%     PVAL = [L,zeros(size(L,1),1); zeros(1,size(L,2)+1)];
% end


% Lplot = Lmean;
axes(ha(k+1));


% if strcmp(cLims,'pval')
%     PVals = 1-Lplot;
%     Lplot(PVals>=0.999) = 4;
%     Lplot(PVals<0.999) = 3;
%     Lplot(PVals<0.99) = 2;
%     Lplot(PVals<0.95) = 1;
% end

% pH = imagesc(x,r,Lmean);
pH = pcolor(xplot,rplot,Lplot);

% shading faceted
set(gca,'YScale','log')
YTicks = round(rplot(1:2:end),2);
% ylim([10^(log10(r(1))-dr) r(end)])
ylim([r(1) 10^(log10(r(end))+dr)])
set(gca,'YTick',YTicks)
YTickLabels = cellstr(num2str(round(log10(YTicks(:)),1), '10^%0.1f'));
set(gca,'YTickLabel',YTickLabels);
% xlabel('Window Position (% of Total Length)','FontSize',fntsz)
% ylabel('Scale r (a.u.)','FontSize',fntsz)
% zlabel('K(r)');


% ax = gca;
% ax = TightAxes(ax);
% set(ax,'YScale','log')
% set(ax,'FontSize',fntsz)
% c1 = colorbar;
% Set axis limits to 3 times the maximum standard deviation of the
% observations.

% caxis(3*[-MaxSD MaxSD]+[MinMean MaxMean]);

% caxis([-0.12327 0.12327]);

% colInt = [5 33 67 146 209 247 253 244 214 178 103;...
%           48 102 147 197 229 247 219 165 96 24 0;...
%           97 172 195 222 240 247 199 130 77 43 31]';
% map = myDivergingMap(colInt,10);


%%%
if strcmp(cLims,'pval')
    caxis([0 1])
    colInts = [0 0.05 0.0500001 1];
    colNames = {'#ca0020','#ca0020','#ffffff','#ffffff'};
else
    caxis(cLims);
    crange = cLims(2)-cLims(1);
    colInts = [0 cLims(2)/crange 1];
    colNames = {'#ca0020','#f7f7f7','#0571b0'};
end

%%% Use these when using the RRK_ComparisonStat
% caxis([-1 1])
% colInts = [0 0.0250 0.5 0.975 1];
% colNames =  {'#2b83ba','#abdda4','#ffffbf','#fdae61','#d7191c'};
map = customcolormap(colInts,colNames);
colormap(map)
end

end

