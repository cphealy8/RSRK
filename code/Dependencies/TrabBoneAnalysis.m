%%
% This code analyses mask images to estimate trabecular bone area, count
% pores, etc... on a frame by frame basis.

%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 
%% Load File
[MaskFile,MaskPath] = uigetfile(fullfile('..\..\data','*bmp'),'Select Mask File');
[PtFile,PtPath] = uigetfile(fullfile('..\..\data','*mat'),'Select pt File');

mask = imread(fullfile(MaskPath,MaskFile));
nFrames = 15;
fOverlap = 0.5;

Frames = Crop2Frames(mask,nFrames,fOverlap);

%% Evaluate Trabecular bone
for k=1:length(Frames)
    props = regionprops(Frames{k},{'Perimeter','Area'});
    perims = [props.Perimeter];
    areas = [props.Area];
    npores(k) = length(perims);
    totPerim(k) = sum(perims);
    totArea(k) = sum(areas);
end

PARatio = totPerim./totArea;

%% Plot
bar(PARatio)