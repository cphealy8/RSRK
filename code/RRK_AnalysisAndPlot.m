%RRK_AnalysisAndPlot Perform RRK Analysis and plot the Results
%   RRK_ANALYSISANDPLOT performs RRK Analysis given the following inputs:
%
%   	POINT PROCESS FILE(S) - Target point proceess(es)(usually obtained
%   	via image segmentation) containing the coordinates of the point
%   	process in the same units as the mask image(s) (usually pixels).
%   	These coordinates should be specified as a 2-column matrix
%   	(x-coordinates in one column, y coordinates in the other) named
%   	'pts' and saved as a .mat file. Each unique point process should be
%   	saved as a separate file and these files should include 'PP' in
%   	their filename followed by a unique identifier to be recognized by
%       this script e.g. PP_MK.mat.
%
%       MASK: A binary mask to specify the analysis region. Masks should be
%       be specified as black and white images and saved as .bmp files.
%       The mask file should include 'ppmask' in it's name to be 
%       recognized by this script e.g. ppmask.bmp. 
%
%       IMAGE SCALE: A txt file that specifies the scale and units of the
%       image e.g. '1.5 px/um' named imscale.txt
%
%   Each of these inputs should be saved together in a folder within
%   the analysis directory specified in the USER INPUT section of this
%   script. This folder defines a single analytical set. 
%   The user can also adjust the parameters of the analysis in
%   the USER INPUT section of the script e.g. number of windows, frame
%   overlap, etc...
%
%   When run RRK_ANALYSISANDPLOT will compute RRK for every point
%   process contained in the analytical set, generate graphs of the
%   results, and save both the raw results and the graphs to a
%   subfolder named results within the analytical sets folder. This
%   script will then move on to analyze any additional analytical sets
%   contained in the directory listed in USER INPUT. 
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

clc; clear; close all;

%% USER INPUT
dirname = '..\data\RSRK Data\'; % Where the input files are located.

% Analysis Parameters
nFrames = 15; % Number of Frames
fOverlap = 0.5; % Overlap between frames
SigLvl = 0.01; % Desired Significance Level
r = [5 10 15 20 30 50 100 150 200 300]; % Analysis scales (r);

Units = 'um';
ScaleUnits = 'um/pixel';

%% Loading Params data (DONT EDIT BELOW HERE)
addpath('Dependencies')

DirDat = dir(dirname);
if isempty(DirDat)
    mkdir(dirname)
    DirDat = dir(dirname);
end

foldnames = {DirDat(3:end).name}';
foldnames(contains(foldnames,'pool'))=[];
if isempty(foldnames)
    warning(strcat(dirname,' contains no data. Analysis terminated.'))
end

%% Analyze
for fID=1:length(foldnames)
    curFold = fullfile(dirname,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    
    % PP file extraction
    PtFiles = curFiles(contains(curFiles,'PP'));
    if isempty(PtFiles)
        error(strcat(curFold,' does not contain a point process file.',...
            ' This must be a .mat file with "PP" in the filename'))
    end
    
    % Mask file extraciton
    MaskName = curFiles(contains(curFiles,'ppmask'));
    if isempty(MaskName)
        error(strcat(curFold,' does not contain a mask file.',...
            'This must be a .bmp file with "ppmask" in the filename'))
    end
    MaskName = MaskName{1};
    Mask = ~imread(fullfile(curFold,MaskName));
    
    fID = fopen(fullfile(curFold,'imscale.txt'));
    imscale = cell2mat(textscan(fID,'%f'));
    fclose(fID);
    rescale = 1/(r(1)*imscale); % [=] pixDRez/pix (if min r = 5)
    %% Scaling and Frames
    % Rescale the image and points (Downsample for computational time);
    MaskA = imresize(Mask,rescale);
    
    Scale = imscale*rescale; % pixDRez/µm
    rA = r*Scale;
    
for pID = 1:length(PtFiles)
    PtsName = PtFiles{pID};
    load(fullfile(curFold,PtsName));
    ptsA = pts*rescale;
    
    hm = msgbox(sprintf('Now analyzing %s',PtsName));
%% Run Simulations
[MaskHeight,MaskWidth] = size(Mask);
win = [0 MaskWidth 0 MaskHeight];

[G,Sig,~,FPosition,~,KScaled,PercEx,KObs,KSims] = RRK_Norm(ptsA,rA,nFrames,fOverlap,SigLvl,'Mask',MaskA);

%% Plot
cLims = [-max(abs(PercEx(:))) max(abs(PercEx(:)))];
[fH1,axM,axH] = RSRK_Plot(r,FPosition,PercEx,'SigMap',Sig,'cLims',cLims);
xlabel('Frame Position (x)');
ylabel('Scale (r)');
cb=colorbar;
ylabel(cb,'Percent Excess Points versus CSR')
%% Save the data
PPIdentifier = extractBetween(PtsName,'PP_','.mat');
FileName = strcat('RRKDat_',PPIdentifier{1},'.mat');
savedir = fullfile(curFold,FileName);
save(savedir,'r','pts','Mask','imscale','nFrames','fOverlap','SigLvl',...
    'G','Sig','FPosition','cLims','KScaled','PercEx','KObs','KSims');

% Save Figures

SaveName = fullfile(curFold,'Results',FileName(1:end-4));
mkdir(fullfile(curFold,'Results'))
saveas(fH1,SaveName,'pdf')
print(fH1,SaveName,'-dpng');   
close(hm)
end
end

S(1) = load('gong');
sound(S(1).y,S(1).Fs)
