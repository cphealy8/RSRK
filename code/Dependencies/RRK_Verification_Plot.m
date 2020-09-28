function [fH,axL,axM,MaxMean,MinMean] = RRK_Verification_Plot(r,FPosition,L,pts,PPName,cLims,T,varargin)
%RRK_VERIFICATION_PLOT Plot RRK Verification Results
%   Detailed explanation goes here
%% parse inputs

p = inputParser;
addRequired(p,'r')
addRequired(p,'FPosition')
addRequired(p,'L')
addRequired(p,'pts')
addRequired(p,'PPName')
addRequired(p,'cLims')
addRequired(p,'T')
addOptional(p,'ptsB',[],@isnumeric)
addOptional(p,'Signal',[],@isnumeric)

parse(p,r,FPosition,L,pts,PPName,cLims,T,varargin{:})

ptsB = p.Results.ptsB;
Signal = p.Results.Signal;
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
if ~isempty(ptsB)
    plot(ptsB(:,1),ptsB(:,2),'db','MarkerSize',3)
elseif ~isempty(Signal)
    imagesc(Signal)
end
hold on
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5);
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
if ~isempty(Signal)
colormap(ha(1),'parula')
end
end

