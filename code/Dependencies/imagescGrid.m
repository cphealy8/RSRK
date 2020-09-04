function [axL,axM] = imagescGrid(x,y,data)
%IMAGESCGRID Summary of this function goes here
%   Detailed explanation goes here
% axdims = [0.1 0.1 0.8 0.8];

axL = gca;
% axL = axes('Position',axdims);
xL = xlim(axL);
yL = ylim(axL);

axL.FontSize = 8;

% axM = axes('Position',axdims);
axM = axes('Position',axL.Position);

fH=imagesc(axM,data);
set(axM,'YDir','normal')

xM = xlim(axM);
yM = ylim(axM);

nx = length(x);
ny = length(y);


xTick = linspace(0,1,2*nx+1);
xTick = xTick(2:2:end);
xspace = floor(length(xTick)/5);
if xspace<1;
    xspace = 1;
end

xTick = xTick(xspace:xspace:end);

axL.XTick = xTick;
axL.XTickLabels = cellstr(num2str(x(xspace:xspace:end)'));


yTick = linspace(0,1,2*ny+1);
yTick = yTick(2:2:end);
yspace = round(length(yTick)/5);
if yspace<1
    yspace = 1;
end

yTick = yTick(yspace:yspace:end);
axL.YTick = yTick;
axL.YTickLabels = cellstr(num2str(y(yspace:yspace:end)'));




axM.XTick = linspace(xM(1),xM(2),nx+1);
axM.YTick = linspace(yM(1),yM(2),ny+1);
grid(axM,'on')
axM.GridAlpha = 1;
axM.XTickLabels = [];
axM.YTickLabels = [];


% xgrid = x(1:end-1)+diff(x)/2;
% ygrid = y(1:end-1)+diff(y)/2;
% 
% axM.XTick = xgrid;
% axM.XAxis.MinorTickValues = x;
% axM.XAxis.MinorTick = 'on';
% 
% axM.YTick = ygrid;
% axM.YAxis.MinorTickValues = y;
% axM.YAxis.MinorTick = 'on';

% grid on


end

