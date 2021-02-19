clc;clear;close all;

[ImFile,ImPath] = uigetfile('../../data/*bmp','Select Cell Mask File');
[ppFile,ppPath] =uigetfile(ImPath,'Select PP File');

cellmask = imread(fullfile(ImPath,ImFile));
load(fullfile(ppPath,ppFile))

imshow(cellmask)
hold on
plot(pts(:,1),pts(:,2),'.r')

imscale = 1.5; % [px/µm]

%% Cell Morphology analysis
props = regionprops(cellmask,'EquivDiameter');
Diam = [props.EquivDiameter]/imscale;

%% Nearest Neighbor analysis
PDist = pairdist(pts,pts);
PDist(PDist==0)=inf;
NNDist = min(PDist)/imscale;

%% Save Results
fname =  strcat(ImFile(1:end-4),'_CellProps.mat');
save(fullfile(ImPath,fname),'Diam','NNDist');
