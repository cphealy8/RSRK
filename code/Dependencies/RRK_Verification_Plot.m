function [fH,axL,axM,MaxMean,MinMean] = RRK_Verification_Plot(r,FPosition,L,pts,PPName,cLims,T,varargin)
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

fH = figure('Position',[50 50 500 100*length(L)]);
[ha,pos] = tight_subplot(length(L)+1, 1, 0, 0.1, 0.15);

axes(ha(1))
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5);
if ~isempty(varargin)
    hold on
    ptsB = varargin{1};
    plot(ptsB(:,1),ptsB(:,2),'db','MarkerSize',3)
end
hold off

axp = gca;
axp.XTick = [];
axp.YTick = [];

% title(PPName)
for k=1:length(L)
Lmean = mean(L{k},3,'omitnan');
x = FPosition{k};
curT = T{k};


axes(ha(k+1));

r=round(r,2);
x=round(x,2);
[axL(k),axM(k)] = imagescGrid(x,r,Lmean);

axes(axM(k))

xL = axM(k).XLim;
yL = axM(k).YLim;

xctrs = linspace(xL(1),xL(2),2*length(x)+1);
xctrs = xctrs(2:2:end);

yctrs = linspace(yL(1),yL(2),2*length(r)+1);
yctrs = yctrs(2:2:end);

[xx,yy] = meshgrid(xctrs,yctrs);
sx = xx(:);
sy = yy(:);


% apply significance test results
Sig = curT<1e-6;
sx(Sig) = [];
sy(Sig) = [];


hold on
plot(sx,sy,'xk');

% if ~isempty(varargin)
%     T2 = varargin{1};
%     curT2 = T2{k};
%     sx2 = xx(:);
%     sy2 = yy(:);
%     Sig2 = curT2<1e-6;
%     sx2(Sig2) = [];
%     sy2(Sig2) = [];
%     plot(sx2,sy2,'ok');
% end
% pH=heatmap(x,r,Lmean);

% Ax = gca;
% Ax.CellLabelColor = 'none';
% Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
% Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
%%% pcolor stuff %%%

% if length(x)>1
%     diffx = x(2)-x(1);
%     xplot = [x(1)-diffx x];
% else
%     xplot = [0 x];
% end
% 
% rplot = [0 r];
% dr = log10(r(2))-log10(r(1));
% Lplot = [Lmean,zeros(size(Lmean,1),1); zeros(1,size(Lmean,2)+1)];

% pH = pcolor(xplot,rplot,Lplot);
% set(gca,'YScale','log')
% YTicks = round(rplot(1:2:end),2);
% 
% ylim([r(1) 10^(log10(r(end))+dr)])
% set(gca,'YTick',YTicks)
% YTickLabels = cellstr(num2str(round(log10(YTicks(:)),1), '10^%0.1f'));
% set(gca,'YTickLabel',YTickLabels);



%%
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

%% Use these when using the RRK_ComparisonStat
map = customcolormap(colInts,colNames);
colormap(map)
colorbar('off')
end
end

