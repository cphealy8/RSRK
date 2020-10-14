function [fH,axL,axM,MaxMean,MinMean] = RSRK_Plot(r,x,K,varargin)
%RRK_VERIFICATION_PLOT Plot RRK Verification Results
%   Detailed explanation goes here
%% parse inputs

p = inputParser;
addRequired(p,'r')
addRequired(p,'FPosition')
addRequired(p,'K')
addOptional(p,'SigMap',[])
addOptional(p,'cLims',[])

parse(p,r,x,K,varargin{:})

SigMap = p.Results.SigMap;
cLims = p.Results.cLims;
%%

fH = figure('Position',[50 50 500 100]);


[axL,axM] = imagescGrid(x,r,K);

axes(axM)

xL = axM.XLim;
yL = axM.YLim;

xctrs = linspace(xL(1),xL(2),2*length(x)+1);
xctrs = xctrs(2:2:end);

yctrs = linspace(yL(1),yL(2),2*length(r)+1);
yctrs = yctrs(2:2:end);

[xx,yy] = meshgrid(xctrs,yctrs);
sx = xx(:);
sy = yy(:);


% apply significance test results
if isempty(SigMap)
    SigMap = zeros(size(K));
end
Sig = SigMap>1e-6;
sx(Sig) = [];
sy(Sig) = [];


hold on
plot(sx,sy,'xk');



%%
if isempty(cLims)
    minK = min(K(:));
    maxK = max(K(:));
    
    if minK<0 && maxK>0
        Krng = max(abs([minK maxK]));
        cLims = [-Krng Krng];
    elseif minK>0 && maxK>0
        cLims = [0 maxK];
    elseif minK<0 && maxK<0
        cLims = [minK 0];
end

caxis(cLims);
crange = cLims(2)-cLims(1);
colInts = [0 cLims(2)/crange 1];
colNames = {'#ca0020','#f7f7f7','#0571b0'};

%% Use these when using the RRK_ComparisonStat
map = customcolormap(colInts,colNames);
colormap(map)
colorbar('off')
end

