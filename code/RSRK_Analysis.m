%RSRK_Analysis Perform RSRK Analysis on a SignalPoint Pattern
%   RSRK_Analysis performs RSRK Analysis given the following inputs:
%       SIGNAL IMAGE(S): A signal image or images. These images should be
%       grayscale and saved as .png files. These images should have
%       'signal' in their name followed by a unique identifier to be
%       recognized by this script e.g. signal_CD31.png
%
%   	POINT PROCESS FILE(S) - Target point proceess(es)(usually obtained
%   	via image segmentation) containing the coordinates of the point
%   	process in the same units as the signal image(s) (usually pixels).
%   	These coordinates should be specified as a 2-column matrix
%   	(x-coordinates in one column, y coordinates in the other) named
%   	'pts' and saved as a .mat file. Each unique point process should be
%   	saved as a separate file and these files should include 'PP' in
%   	their filename followed by a unique identifier to be recognized by
%       this script e.g. PP_MK.mat.
%
%       MASK: A binary mask to specify the analysis region. Masks should be
%       be specified as black and white images and saved as .bmp files. The
%       resolution of the mask should exactly match the resolution of the
%       input signal images. The mask file should include 'ppmask' in the
%       it's name to be recognized by this script e.g. ppmask.bmp. 
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
%   When run RSRK_Analysis will compute RSRK for every point process and
%   signal pair contained in the analysis folder. The results of this
%   analysis will be saved to the same folder and will tonatin the suffice
%   'RSRKDat' in their filename followed by the unique IDs for the signal
%   and point process that went into the analysis and the time at which the
%   analysis was completed (YYYYMMDD-HHMM) e.g.
%   RSRKDat_CD31-to-MK_20210211-0139.mat.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

clc; clear; close all;

%% INSTRUCTIONS
% This code runs the RSRK analysis. RSRK requires several input files in
% order to calculated. It requires a point process file (PP.mat), mask file
% (ppmask.bmp), Signal file(s) (signal.png), and a txt file that provides
% the image scale (imscale.txt). These should be contained in a folder in
% the directory listed below (dirname).
%
% This script will import the input files noted above and perform RSRK 
% comparing the input point process to each of the signal files provided
% then output the results as separate .mat files in the same directory.
%% USER INPUT
%%% Analysis Directory specification
% Specify the directory where the input files needed for RSRK analysis are
% stored. Output files are also stored here.
dirname = '..\data\RSRK Data\';

%%% Analysis Parameters
nFrames = 15; % Number of Frames to use in RSRK analysis. 
fOverlap = 0.5; % Overlap between neighboring frames. 
SigLvl = 0.5; % Desired significance level of results. 

% Analysis scales (r). The spatial scales at which RSRK assesses
% patterning.
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm

% Analysis units
Units = 'um';
ScaleUnits = 'um/pixel';

%% Loading params data
addpath('Dependencies')
starttime = clock;
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
t1 = tic;
for fID=1:length(foldnames)
    curFold = fullfile(dirname,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    isSigData = contains(curFiles,'signal')&contains(curFiles,'png');
    
    % Signal File Extraction
    SigFiles = curFiles(isSigData);
    if isempty(SigFiles)
        error(strcat(curFold,' does not contain a signal file.',...
            'This must be a grayscale .png file with "signal" in the filename'))
    end
    
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
    mask = ~imread(fullfile(curFold,MaskName));
    
    fID = fopen(fullfile(curFold,'imscale.txt'));
    imscale = cell2mat(textscan(fID,'%f'));
    fclose(fID);
    rescale = 1/(r(1)*imscale); % [=] pixDRez/pix (if min r = 5)

%% Scaling and Frames
    % Set window width
    FrameWidth = WWidth(mask,nFrames,fOverlap);
    % Rescale the image and points (Downsample for computational time);
%     ptsA = pts*rescale;
    maskA = imresize(mask,rescale);
    
    framewidthA = FrameWidth*imscale;

    [SHeight,SWidth] = size(mask);
    
    Scale = imscale*rescale; % pixDRez/µm
    rA = r*Scale;
    
for sID =1:length(SigFiles)
for pID = 1:length(PtFiles)
    PtsName = PtFiles{pID};
    load(fullfile(curFold,PtsName));
    ptsA = pts*rescale;
    
    SigName = SigFiles{sID};
    
    hm = msgbox(sprintf('Now analyzing %s',SigName));
    Signal = imread(fullfile(curFold,SigName));
    
    SignalA = imresize(Signal,rescale);

%% Analysis
npts = length(pts);

[RK,FPosition] = MovingRKSig(SignalA,ptsA,rA,maskA,'Pts2Sig',nFrames,fOverlap,SigLvl,'X');

tempStruct = cell2mat(RK);
KObs = vertcat(tempStruct.Obs)';
KCSR = vertcat(tempStruct.CSR)';

% Convert back to original scale
FPosition = FPosition/Scale;
                    
% Calling this K to simplify coding but it's really G(r). 
K = log2(KObs./KCSR);

endtime = clock;

TimeElapsed = etime(endtime,starttime)/60;
        
%% Save the data
tottime = toc(t1); 
close(hm)

SigIdentifier = extractBetween(SigName,'signal_','.png');
PPIdentifier = extractBetween(PtsName,'PP_','.mat');
SigIdentifier = SigIdentifier{1};
PPIdentifier = PPIdentifier{1};
SigPPIdentifier = strcat(PPIdentifier,'-to-',SigIdentifier);

FileName = strcat(SigName(1:end-4),'_RSRKDat_',SigPPIdentifier,'_',TimeID,'.mat');
savedir = fullfile(curFold,FileName);
save(savedir,'RK','Signal','KObs','KCSR','K','npts','r','FPosition',...
     'pts','nFrames','mask','imscale','rescale','TimeElapsed',...
     'FrameWidth','nFrames','fOverlap','SigLvl');

end
end
end
%%    
S(1) = load('gong');
sound(S(1).y,S(1).Fs)
