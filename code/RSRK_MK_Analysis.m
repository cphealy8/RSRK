   clc; clear; close all;
addpath('Dependencies')
addpath('Dependencies');
dirname = '..\data\Kokliaris Dataset\';
DirDat = dir(dirname);
foldnames = {DirDat(3:end).name}';
SaveDir = '..\results\Kokliaris Dataset\';

SaveTag = 'n15MaskA';


starttime = clock;
%% Analysis Params
nFrames = 15;
FrameWidth = 2000; %[=]um

fOverlap = 0.5;


% imscale = 1.50; % pix/µm
SigLvls = [0.05];

% Analysis scales (r);
% r = [10 20 30 50 90 160 290 500]; %[=] µm
r = [5 10 15 20 30 50 100 150 200 300]; %[=] µm
% r = 10:10:100; %[=] µm



Units = 'um';
ScaleUnits = 'um/pixel';

%% Loading params data
% [ImFile,ImPath] = uigetfile('../data/*png','Select Signal Image');
% [MaskFile,MaskPath] = uigetfile(fullfile(ImPath,'*bmp'),'Select Mask File');
% [PtFile,PtPath] = uigetfile(fullfile(ImPath,'*mat'),'Select Points File');

dirname = '..\data\Kokliaris Dataset\';
DirDat = dir(dirname);
foldnames = {DirDat(3:end).name}';
SaveDir = '..\data\Kokliaris Dataset\';

foldnames(contains(foldnames,'pool'))=[];
%% Analyze
t1 = tic;
for fID=1:length(foldnames)
% for fID = [10 11]
% load data
    curFold = fullfile(dirname,foldnames{fID});
    curDirDat = dir(curFold);
    curFiles = {curDirDat(3:end).name}';
    isSigData = (contains(curFiles,'_R')|contains(curFiles,'_G')|contains(curFiles,'_B'))&contains(curFiles,'png');
    
    SigFiles = curFiles(isSigData);
    
    PtsName = curFiles(contains(curFiles,'PP'));
    PtsName = PtsName{1};
    load(fullfile(curFold,PtsName));
    
    MaskName = curFiles(contains(curFiles,'ppmask'));
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
    
    % If you want to use a constant number of frames and a fixed overlap
    % specify nFrames and fOverlap as constants and comment out the
    % following line.
%     [nFrames,fOverlap] = compFrames(SWidth,fOverlap,framewidthA); 

    
    Scale = imscale*rescale; % pixDRez/µm
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
FileName = strcat(SigName(1:end-4),'_MKRK_',SaveTag,'.mat');
savedir = fullfile(curFold,FileName);
save(savedir,'RK','Signal','KObs','KCSR','K','npts','r','FPosition',...
     'pts','nFrames','mask','imscale','rescale','TimeElapsed','FrameWidth','nFrames','fOverlap');

end
end
    
%%    
S(1) = load('gong');
sound(S(1).y,S(1).Fs)
