clc; clear; close all;
cnt = 0;

DatPath = '../../data/*mat';
while 1
    cnt = cnt+1;
    
    [DatFile{cnt},DatPath]= uigetfile(DatPath,'Select RRK Data File');
    filepath{cnt} = fullfile(DatPath,DatFile{cnt});
    if DatFile{cnt}==0
        cnt = cnt-1;
        break
    end
    
    % Load and plot results of RRK analysis
    load(filepath{cnt},'PercEx','KSims');
    [sl,sw,sd] = size(KSims);
    [pl,pw] =size(PercEx);
    
    if (sl==pw)
        PercEx = permute(PercEx,[2 1 3]);
    end
    
    nsims{cnt} = size(KSims,3); 
    minP(cnt)= min(PercEx(:)*100);
    maxP(cnt)= max(PercEx(:)*100);
end

lim = max(abs([minP maxP]));
cLims = [-lim lim];


for k = 1:cnt
    load(filepath{k},'PercEx','r','Frame','Sig')
    
if ~exist('Frame')
    [nFrames,nr] = size(PercEx);
    if length(r)~=nr
        PercEx = PercEx';
        [nFrames,nr] = size(PercEx);
    end
    Frame = round(linspace(0,100,nFrames));
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