%ANALYZEEXTRAS quantify cell density and bone type densities.
%   ANALYZEEXTRAS estimates cell density and the density of trabecular
%   bone, cortical bone, and bone marrow as a function of frame position.
%   When run, ANALYZEEXTRAS will prompt the user to select a point process
%   file, and binary mask (ppmask). A Binary mask that marks the bone (including both
%   cortical bone, trabecular bone, and bone marrow)that contains
%   'outermask' in it's filename must be contained within the same folder
%   as the point process and ppmask. Additionally, a binary mask that marks
%   just the cortical bone that contains 'corticalmask' in its name, and
%   a mask that marks cartilage that contains 'cartilagemask' in its name
%   must also be saved to the same folder as the point process and ppmask. 
%
%   If all the correct files are present then ANALYZEEXTRAS will compute
%   the cell density, cortical bone density, trabecular bone density, and
%   bone marrow density as a function of the frame position. Users can
%   adjust the parameters for how this analysis is performed in the USER
%   INPUT section of this script. 
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

clc; clear; close all;

%% USER INPUT
nFrames = 15; % Number of Frames
fOverlap = 0.5; % Frame Overlap
imscale = 1.50; % Image scale [=] pix/µm

%% Bone Analysis
Frame = linspace(0,1,nFrames)*100;
addpath('Dependencies')
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
    CartMask = zeros(size(OMask));
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