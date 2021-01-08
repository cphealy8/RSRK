clc; clear; close all;
addpath('Dependencies');
% RKFilename = strcat('../data/MovingRK/MovingRKdata_',figname,'_',marker,'.mat');

[FileName,LoadPath] = uigetfile('../data/MovingRK/*.mat','Select Moving RK Data File');
load(strcat(LoadPath,FileName))
% scale = 0.69; % µm/pixel
scale = Scale;
ncats = length(RK{1}.SigLvls)+1;
nr = length(RK{1}.r);
cats = 1:ncats;

for k = 1:length(x)
    % First normalize to CSR
    NormRK{k} = NormalizeRK(RK{k});
    
    % Set the categorization based The observed RK's relationship to the
    % Significance levels.
    RKObs(k,:) = NormRK{k}.Obs;
    r = NormRK{k}.r;
    RKSims = NormRK{k}.Env;
    for n = 1:nr
        Bounds = RKSims(:,nr);
        RKCat(k,n) = Cont2Cat(RKObs(k,n),Bounds);
    end
end

% Because Colorbars are weird in matlab
RKCat = RKCat-0.1;

f1 = figure('Units','points','Position',[300 300 400 150]);
fntsz = 10;

% Because matlab is stupid
r = log10(r);
dr = r(2)-r(1);
r = 10.^[r r(end)+dr];
r = r*scale;
r(end) = 60;

x = x./x(end)*100;
dx = x(2)-x(1);
x = [x x(end)+dx];

% Pad with zeros
RKCat = [RKCat,zeros(size(RKCat,1),1); zeros(1,size(RKCat,2)+1)];

pcolor(x,r,RKCat')
colorbar
% imagesc(x,log10(r*scale),RKCat')
% axis xy
% shading interp

xlabel('Window Position (% of Total Length)','FontSize',fntsz)
ylabel('Scale r (µm)','FontSize',fntsz)

ax = gca;
ax = TightAxes(ax);
% ax.YTick = [10 20 50 100 200 500];
set(gca,'layer','top')
% colors = [43 171 255 253 215; 131 221 255 174 25; 186 164 191 97 28]/255';
% colors = [ 102 171 255 253 244 ;  194 221 255 174 109 ;  165 164 191 97 67 ]/255';
% colors = [50 102 171 255 253 244 213; 136 194 221 255 174 109 62; 189 165 164 191 97 67 79]/255';
colors = [43 171 255 253 215; 131 221 255 174 25; 186 164 191 97 28]/255';
CatColormap(cats,colors,ax);
% colorbar
% set(ax,'YScale','log')
set(ax,'FontSize',fntsz)
SavePath = '../results/MovingRKPlots/';
saveas(f1,strcat(SavePath,FileName(1:end-4),'_SigLvls'),'epsc')

%% Surface plot
% X = repmat(x(1:end-1)',[1 length(r)-1]);
% R = repmat(r(1:end-1),[length(x)-1 1]);

f2 = figure('Units','points','Position',[300 300 400 150]);
RKObs= [RKObs,zeros(size(RKObs,1),1); zeros(1,size(RKObs,2)+1)];

p1 = pcolor(x,r,RKObs');
xlabel('Window Position (% of Total Length)','FontSize',fntsz)
ylabel('Scale r (µm)','FontSize',fntsz)
zlabel('(RK_{observed}/RK_{CSR}) - 1')


ax = gca;
ax = TightAxes(ax);
% set(ax,'YScale','log')
set(ax,'FontSize',fntsz)
c1 = colorbar;
% colormap inferno
colInt = [5 33 67 146 209 247 253 244 214 178 103;...
          48 102 147 197 229 247 219 165 96 24 0;...
          97 172 195 222 240 247 199 130 77 43 31]';
map = myDivergingMap(colInt,10);
colormap(map)
% colormax = max(abs(RKObs(:)));
colormax = 3;
caxis([-colormax colormax])

nticks = 8;
c1.Ticks = log2(unique([linspace(1/(2^colormax),1,nticks) linspace(1,2^colormax,nticks)]));
c1.Color = [0 0 0];
% ax.YTick = [10 20 50 100 200 500];
ax.YColor = [0 0 0];
ax.XColor = [0 0 0];
set(gca,'layer','top')
saveas(f2,strcat(SavePath,FileName(1:end-4),'_KObs'),'epsc')


min(RKObs(RKObs~=-Inf))
max(RKObs(:))
%%
function [NormRK] = NormalizeRK(RK)
    NormRK = RK;
    NormRK.Obs = log2(RK.Obs./RK.CSR);
    NormRK.CSR = log2(RK.CSR./RK.CSR);
    
    for n = 1:length(RK.Env)
        NormRK.Env = log2(RK.Env./RK.CSR);
    end
end
