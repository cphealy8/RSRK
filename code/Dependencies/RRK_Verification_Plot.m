function [fH,pH] = RRK_Verification_Plot(r,FPosition,L)
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

fH = figure;
[ha,pos] = tight_subplot(length(L), 1, 0, 0.1, 0.1);

for k=1:length(L)
Lmean = mean(L{k},3);
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


Lplot = [Lmean,zeros(size(Lmean,1),1); zeros(1,size(Lmean,2)+1)];

% Lplot = Lmean;
axes(ha(k));
% pH = imagesc(x,r,Lmean);
pH = pcolor(xplot,rplot,Lplot);
% shading faceted
set(gca,'YScale','log')

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

caxis(3*[-MaxSD MaxSD]+[MinMean MaxMean]);
% colormap inferno
% map = diverging_map(linspace(0,1,64),[0.23 0.299 0.754],[0.706 0.016 0.150]);
colInt = [5 33 67 146 209 247 253 244 214 178 103;...
          48 102 147 197 229 247 219 165 96 24 0;...
          97 172 195 222 240 247 199 130 77 43 31]';
map = myDivergingMap(colInt,10);
colormap(map)
end

end

