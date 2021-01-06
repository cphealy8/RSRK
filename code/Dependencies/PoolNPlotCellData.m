clc; clear; close all;

%% Load Data
DatPath = '../../data/*mat';
sDiam = [];
sNNDist = [];
while 1
    [DatFile,DatPath] = uigetfile(DatPath,'Select Cell Data File');
    if DatFile==0
        break
    end
    load(fullfile(DatPath,DatFile));
    
    sDiam = [sDiam Diam];
    sNNDist = [sNNDist NNDist];
    
    pathparts = strsplit(DatPath,filesep);
    DatPath = strjoin(pathparts(1:end-2),filesep);
end

%% Plot
fH=figure('Units','centimeters','Position',[2 2 14 7]);
subplot(1,2,1)
HistStatPlot(sNNDist,'StatType','Median')
xlabel('Nearest Neighbor Distance (µm)')
ylabel('Population Fraction');

subplot(1,2,2)
HistStatPlot(sDiam,'StatType','Median')
xlabel('Approximate Diameter (µm)')
ylabel('Population Fraction')

%% Save
savename = inputdlg('Output File Name');
[savepath] = uigetdir;
saveas(fH,fullfile(savepath,savename{1}),'pdf');
save(fullfile(savepath,strcat(savename{1},'_pooleddata.mat')),'sDiam','sNNDist');

close all