%AVERAGEEXTRAS compute average bone density and cell densities output from
%ANALYZEEXTRAS
%
%   SEE ALSO ANALYZEEXTRAS.
%
%   Author: Connor P. Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah

%%
clc; clear; close all;
cnt = 0;

% Read data
while 1
    cnt = cnt+1;
    
    [DatFile{cnt},DatPath]= uigetfile('../../data/*mat','Select RRK Data File');
    filepath{cnt} = fullfile(DatPath,DatFile{cnt});
    if DatFile{cnt}==0
        cnt = cnt-1;
        break
    end
    % Read and store results of RRK analysis
    load(filepath{cnt})
    kCortFrac(cnt,:) = CortFrac;
    kMarrowFrac(cnt,:) = MarrowFrac;
    kTrabFrac(cnt,:) = TrabFrac;
    kCellDensity(cnt,:) = CellDensity;
end
clear CortFrac MarrowFrac TrabFrac CellDensity

% Compute stats
CortFrac = MainStats(kCortFrac);
MarrowFrac = MainStats(kMarrowFrac);
TrabFrac = MainStats(kTrabFrac);
CellDensity = MainStats(kCellDensity);

%% Save
uisave({'Frame','CortFrac','MarrowFrac','TrabFrac','CellDensity'},'Extras_Averaged')