clc; clear; close all;
addpath('Dependencies')
dirname = '..\data\RSRK Data\';
SaveDir = '..\results\RSRK Data\';

starttime = clock;

%% Analysis Params
nFrames = 15;
fOverlap = 0.5;
SigLvl = 0.5;

% Analysis scales (r);
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm

Units = 'um';
ScaleUnits = 'um/pixel';

%% Loading params data
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
    PtsName = curFiles(contains(curFiles,'PP'));
    if isempty(PtsName)
        error(strcat(curFold,' does not contain a point process file.',...
            ' This must be a .mat file with "PP" in the filename'))
    end
    PtsName = PtsName{1};
    load(fullfile(curFold,PtsName));
    
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
    ptsA = pts*rescale;
    maskA = imresize(mask,rescale);
    
    framewidthA = FrameWidth*imscale;

    [SHeight,SWidth] = size(mask);
    
    Scale = imscale*rescale; % pixDRez/µm
    rA = r*Scale;
    
for sID =1:length(SigFiles)
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
%%    
S(1) = load('gong');
sound(S(1).y,S(1).Fs)
