% Load File
[MaskFile,MaskPath] = uigetfile(fullfile('..\..\data','*bmp'),'Select Mask File');


[RKFile,RKPath] = uigetfile(fullfile(MaskPath,'*mat'),'Select RK File');
load(fullfile(RKPath,RKFile));

mask = imread(fullfile(MaskPath,MaskFile));
nFrames = 15;
fOverlap = 0.5;

Frames = Crop2Frames(mask,nFrames,fOverlap);

%% Evaluate Trabecular bone
for k=1:length(Frames)
    props = regionprops(Frames{k},{'Perimeter'});
    perims = [props.Perimeter];
    npores(k) = length(perims);
    maskPerim(k) = sum(perims);
    maskArea(k) = sum(sum(Frames{k}));
end
frame = 0:nFrames-1;
frame =100*frame./max(frame);

PARatio = maskPerim./maskArea;
PARatio = PARatio-min(PARatio);

%% Get point and signal data;

npts = ExtractParam(RK,'npts');
pixTot = ExtractParam(RK,'pixTot');
imA = ExtractParam(RK,'A');

SigRatio = pixTot;
ptDensity = npts./maskArea;

%% Normalize
SigRatio = SigRatio./max(SigRatio);
PARatio = PARatio./max(PARatio);
maskArea = maskArea./max(maskArea);
ptDensity = ptDensity./max(ptDensity);

%% Plot
fH = figure('Position',[50 50 1000 200]);
lwd = 2;
plot(frame,PARatio,'LineStyle','-','Color',[31 120 180]/255,'LineWidth',lwd)
hold on
plot(frame,SigRatio,'LineStyle',':','Color',[166 206 227]/255,'LineWidth',lwd)
plot(frame,maskArea,'LineStyle','--','Color',[178 223 138]/255,'LineWidth',lwd)
plot(frame,ptDensity,'LineStyle','-.','Color',[51 160 44]/255,'LineWidth',lwd)

xlabel('Frame Position (%)')
ylabel('% of Maximum')
legend({'Trabecular Area','Total Signal','Marrow Area','MK Density'},'Location','WestOutside')