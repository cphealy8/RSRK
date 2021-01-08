clc; clear; close all;
addpath('Dependencies')
dirname = '..\data\RSRK Data\';
SaveDir = '..\results\RSRK Data\';
SaveTag = 'test';

starttime = clock;
%% Analysis Params
nFrames = 15;
FrameWidth = 2000; %[=]um
fOverlap = 0.5;

SigLvls = 0.05;

% Analysis scales (r);
r = [5 10 15 20 30 50 100 150 200 300]; %[=] �m

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
    
    SigFiles = curFiles(isSigData);
    
    PtsName = curFiles(contains(curFiles,'PP'));
    PtsName = PtsName{1};
    load(fullfile(curFold,PtsName));
    
    MaskName = curFiles(contains(curFiles,'mask'));
    MaskName = MaskName{1};
    mask = ~imread(fullfile(curFold,MaskName));
    
    fID = fopen(fullfile(curFold,'imscale.txt'));
    imscale = cell2mat(textscan(fID,'%f'));
    fclose(fID);
    rescale = 1/(r(1)*imscale); % [=] pixDRez/pix (if min r = 5)

%% Scaling and Frames
    % Rescale the image and points (Downsample for computational time);
    ptsA = pts*rescale;
    maskA = imresize(mask,rescale);
    
    framewidthA = FrameWidth*imscale;

    [SHeight,SWidth] = size(mask);
    
    Scale = imscale*rescale; % pixDRez/�m
    rA = r*Scale;
    
for sID =1:length(SigFiles)
    SigName = SigFiles{sID};
    hm = msgbox(sprintf('Now analyzing %s',SigName));
    Signal = imread(fullfile(curFold,SigName));
    
    SignalA = imresize(Signal,rescale);

%% Analysis
npts = length(pts);

[RK,FPosition] = MovingRKSig(SignalA,ptsA,rA,maskA,'Pts2Sig',nFrames,fOverlap,SigLvls,'X');

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
FileName = strcat(SigName(1:end-4),'_RSRKDat_',SaveTag,'.mat');
savedir = fullfile(curFold,FileName);
save(savedir,'RK','Signal','KObs','KCSR','K','npts','r','FPosition',...
     'pts','nFrames','mask','imscale','rescale','TimeElapsed','FrameWidth','nFrames','fOverlap');

end
end
    
%%    
S(1) = load('gong');
sound(S(1).y,S(1).Fs)
