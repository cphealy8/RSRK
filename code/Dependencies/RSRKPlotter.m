%% Select, Plot, and Save RSRK results.
% RSRKPLOTTER will prompt the user to select RSRK results in series. When
% you have finished click cancel in the prompt. RSRKPLOTTER will then read
% and plot the results you selected using the same scale. Results are saved
% under '..\..\results\RSRK'.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 
%%
clc; clear; close all;
cnt = 0;
DatPath = '../../data/*mat';
while 1
    cnt = cnt+1;
    
    [DatFile{cnt},DatPath]= uigetfile(DatPath,'Select RSRK Data File');
    filepath{cnt} = fullfile(DatPath,DatFile{cnt});
    if DatFile{cnt}==0
        cnt = cnt-1;
        break
    end
    
    % Standardize
    load(filepath{cnt},'KObs','KCSR','r','RK');
    if ~exist('KObs')
        KObs = ExtractParam(RK,'Obs')'; 
    end
    if ~exist('KSims')
        KSims = ExtractParam(RK,'CSRSims');
    end
    rc{cnt} = r;
    [PercEx{cnt},~,Sig{cnt},alpha{cnt}] = RRKSigStandard(KObs,KSims);
    PercEx{cnt}= PercEx{cnt}*100;
    
    % save minima and maxima
    minP(cnt)= min(PercEx{cnt}(:));
    maxP(cnt)= max(PercEx{cnt}(:));
    
    clear KObs KSims r RK
    
end

lim = max(abs([minP maxP]));
cLims = [-lim lim];


for k = 1:cnt
[nFrames,nr] = size(PercEx{k});
Frame = round(linspace(0,100,nFrames));
[fH,axM,axH] = RSRK_Plot(rc{k},Frame,PercEx{k}','SigMap',Sig{k}','cLims',cLims);
cbar = colorbar(axH,'North');
xlabel(cbar,sprintf('%% Excess versus CSR\nx=NS vs. CSR \\alpha=%0.2f',alpha{cnt}))
fH.Units = 'Centimeters';
fH.Position = [1 1 9.5 6.0];

xlabel(axH,'Frame(%)')
ylabel(axH,'Scale (µm)')
SaveDir = '..\..\results\RSRK';
SaveFile = DatFile{k}(1:end-4);
SaveName = fullfile(SaveDir, SaveFile);
saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng');

close all
end