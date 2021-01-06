clc;clear;close all;
%% load data
DatPath = '../../data/*mat';

k = 0;
sDiam{1} = [];
sNNDist{1} = [];

k=1;
while 1
    answer = questdlg('Handle File', ...
            'How do you want to handle this data?', ...
            'Append','Continue','End','End');
    
    switch answer
        case 'Append'
        case 'Continue'
            k = k+1;
            sDiam{k} = [];
            sNNDist{k} = [];
        case 'End'
            break
    end
    
    [DatFile,DatPath] = uigetfile(DatPath,'Select Cell Data File');
    
    if DatFile==0
        break
    end
    load(fullfile(DatPath,DatFile));
    
    sDiam{k} = [sDiam{k} Diam];
    sNNDist{k} = [sNNDist{k} NNDist];
    
    pathparts = strsplit(DatPath,filesep);
    DatPath = strjoin(pathparts(1:end-2),filesep);
end

%% Perform T-Tests
combos = nchoosek(1:k,2);
for i =1:size(combos,1)
    n = combos(i,1);
    m = combos(i,2);
    [~,pDiam(i)] = ttest2(log10(sDiam{n}),log10(sDiam{m}));
    [~,pNNDist(i)] = ttest2(log10(sNNDist{n}),log10(sNNDist{m}));
end

%% Other stats
for j=1:k
    meanDiams(j) = mean(sDiam{j});
    meanNNDist(j) = mean(sNNDist{j});
    sdDiams(j) = std(sDiam{j});
    sdNNDist(j) = std(sNNDist{j});
    CIDiams(j) = quickConfInt(sDiam{j},'alpha',1e-2);
    CINNDist(j) = quickConfInt(sNNDist{j},'alpha',1e-2);
end

%%
figure('Units','centimeters','Position',[2 2 19 8]);
subplot(1,2,1)
bar(meanDiams,0.5,'linewidth',1.5)
hold on
errorbar(meanDiams,CIDiams,'.k','linewidth',1.5);

ylabel('Cell Diameter (µm)');
subplot(1,2,2)
bar(meanNNDist,0.5,'linewidth',1.5)
hold on
errorbar(meanNNDist,CINNDist,'.k','linewidth',1.5);
ylabel('Nearest Neighbor Distance (µm)');

