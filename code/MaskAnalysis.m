%% Mask Analysis
% Determine maximum interpretable scale for each window.
% The max interpretable scale is defined as the radius of the circle with
% equivalent area to the largest region in the mask.
addpath('Dependencies')
ImScale = 0.69; % Image scale Units/pixel [original coutu dataset]

% Moving Window Settings
WindowOverlap = 0.5;
nWindows = 10;

% Vector defining the scales to be analyzed by RSRK (Change to match)  
r = logspace(log10(10),log10(500),10); 

[MaskFile,MaskPath] = uigetfile('../data/images/*bmp','Select Mask File');
mask = ~imread(strcat(MaskPath,MaskFile));

[MaxPix] = MaskAnalyze(mask,nWindows,WindowOverlap,'median')*ImScale;

% Vector of maximum interpretable r's for each window. 
rint = roundtowardvec(MaxPix,r,'floor');

rnum = rint;

% Index of maximum interpretable r.
for n=1:length(r)
    rnum(rint==r(n))=n;
end
rnum(isnan(rnum))=0;
rnum'