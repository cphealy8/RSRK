clc;clear;close all;
cnt=0;

DatPath = '../../data/*mat';
%% Read and convert the datasets
while 1
    [DatFile,DatPath]= uigetfile(DatPath,'Select RRK Data File');
    if DatFile==0
        break
    end
    load(fullfile(DatPath,DatFile),'r','KObs','KSims','Mask','pts','nFrames','fOverlap');
    cnt = cnt+1;
    
    MaskF = Crop2Frames(Mask,nFrames,fOverlap);
    PtsF = Crop2Frames(Mask,nFrames,fOverlap,pts);
    
    for k=1:nFrames
        Ai(k,cnt) = sum(MaskF{k}(:));
        nptsi(k,cnt) =length(PtsF{k});
        LInvi(k,cnt) = Ai(k,cnt)./(nptsi(k,cnt).*(nptsi(k,cnt)-1));
    end
    EObsi(:,:,1,cnt) = bsxfun(@rdivide,KObs,LInvi(:,cnt));
    ESimsi(:,:,:,cnt) = bsxfun(@rdivide,KSims,LInvi(:,cnt));
end

Frame = round(linspace(0,1,nFrames)*100);
msets = cnt;
%% Pool Parts
EObs = sum(EObsi,4);
ESims = sum(ESimsi,4);
npts = sum(nptsi,2);
A = sum(Ai,2);

LInv = A./(npts.*(npts-msets));

KObs = bsxfun(@times,EObs,LInv);
KSims = bsxfun(@times,ESims,LInv);

[PercEx,G,Sig,KMean] = RRKSigStandard(KObs,KSims);

%% Plot
[fH1,axM,axH] = RSRK_Plot(r,Frame,PercEx','SigMap',Sig');

%% Save
uisave({'EObs','r','Frame','ESims','npts','A','KObs','KSims','PercEx','G','Sig','KMean'});

% Save Figures
% SaveFile = strcat(PtFile(1:end-4),'_RRK_G');
% SaveName = fullfile(SaveDir, SaveFileG);
% saveas(fH1,SaveName,'pdf')
% print(fH1,SaveName,'-dpng'); 