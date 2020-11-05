clc; clear; close all;
cnt = 0;
while 1
    cnt = cnt+1;
    
    [DatFile{cnt},DatPath]= uigetfile('../../data/*mat','Select RRK Data File');
    filepath{cnt} = fullfile(DatPath,DatFile{cnt});
    if DatFile{cnt}==0
        cnt = cnt-1;
        break
    end
    
     
    % Load and plot results of RRK analysis
    load(filepath{cnt},'PercEx','KSims');
    nsims{cnt} = size(KSims,3); 
    minP(cnt)= min(PercEx(:)*100);
    maxP(cnt)= max(PercEx(:)*100);
end


for k = 1:cnt
    load(filepath{k},'PercEx','r','Frame','Sig')
if ~exist('Frame')
    [nFrames,nr] = size(PercEx);
    Frame = round(linspace(0,1,nFrames));
end
alpha = 2/(nsims{k}+1);

if size(PercEx,1)~=size(Sig,1)
    Sig = Sig';
end

[fH,axM,axH] = RSRK_Plot(r,Frame,100*PercEx','SigMap',Sig','cLims',cLims);
cbar = colorbar(axH,'North');
xlabel(cbar,sprintf('%% Excess versus CSR\nx=NS vs. CSR \\alpha=%0.2f',alpha))
fH.Units = 'Centimeters';
fH.Position = [1 1 9.5 6.0];

xlabel(axH,'Frame(%)')
ylabel(axH,'Scale (µm)')
SaveDir = '..\..\results\RRK';
SaveFile = DatFile{k}(1:end-4);
SaveName = fullfile(SaveDir, SaveFile);
saveas(fH,SaveName,'pdf')
print(fH,SaveName,'-dpng');

close all
end