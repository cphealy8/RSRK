clc; clear; close all;
addpath('Dependencies')
%% Analysis Params
nFrames = 15;
fOverlap = 0.5;
imscale = 1.50; % pix/µm
SigLvl = 0.01;
Frame = linspace(0,1,nFrames)*100;
%% Bone Analysis
[MaskFile,MaskPath]  = uigetfile('../data/*bmp','Select Mask File');
Mask = ~imread(fullfile(MaskPath,MaskFile));

[PtFile,PtPath] = uigetfile(MaskPath,'Select Point File');
load(fullfile(PtPath,PtFile),'pts');

MaskRoot = MaskFile(1:end-11);
CMaskFile  = strcat(MaskRoot,'_corticalmask.bmp');
CMask = ~imread(fullfile(MaskPath,CMaskFile));
OMaskFile  = strcat(MaskRoot,'_outermask.bmp');
OMask = ~imread(fullfile(MaskPath,OMaskFile));
CartMaskFile = strcat(MaskRoot,'_cartilagemask.bmp');

try
    CartMask = ~imread(fullfile(MaskPath,CartMaskFile));
catch
    CartMask = ones(size(OMask));
end

TrabBone = ~Mask.*OMask.*CMask.*~CartMask;
CortBone = OMask&~CMask;
Marrow = OMask&Mask;

TrabBoneF = Crop2Frames(TrabBone,nFrames,fOverlap);
CortBoneF = Crop2Frames(CortBone,nFrames,fOverlap);
OMaskF = Crop2Frames(OMask,nFrames,fOverlap);
MarrowF = Crop2Frames(Marrow,nFrames,fOverlap);
cellsF = Crop2Frames(Marrow,nFrames,fOverlap,pts);

for k = 1:nFrames
    ATrab(k) = sum(TrabBoneF{k}(:));
    ACort(k) = sum(CortBoneF{k}(:));
    AMarrow(k) = sum(MarrowF{k}(:));
    TotA(k) = sum(OMaskF{k}(:));
    
    nCells(k) = length(cellsF{k});
end

%% Summary statistics
TrabFrac = ATrab./TotA;
CortFrac = ACort./TotA;
MarrowFrac = AMarrow./TotA;
CellDensity = nCells./(AMarrow/(imscale^2)); % [=] cells/um^2

%% Plot
fh = figure('Units','centimeters','Position',[1 1 9.5 6.5]);
lwd = 2;

yyaxis left
plot(Frame,MarrowFrac,'LineWidth',lwd)
hold on
plot(Frame,CortFrac,'LineWidth',lwd)
plot(Frame,TrabFrac,'LineWidth',lwd)
xlabel('Frame Position (%)')
ylabel('Area Fraction');

yyaxis right
plot(Frame,CellDensity,'LineWidth',lwd)
ylabel('Cell Density (Cells/{µm^2})')

legend('Marrow','Cortical Bone','Trabecular Bone','MK','Location','best')

%% Save
SaveDir = '..\results\Extras';
SaveFile = strcat(MaskRoot,'_Extras');
save(fullfile(MaskPath,strcat(SaveFile,'.mat')),'Frame','MarrowFrac','CortFrac','TrabFrac','CellDensity')
SaveName = fullfile(SaveDir, SaveFile);
saveas(fh,SaveName,'pdf')
print(fh,SaveName,'-dpng');   