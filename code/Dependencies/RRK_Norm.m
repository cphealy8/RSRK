function [G,Sig,r,FPosition,cLims,KScaled] = RRK_Norm(pts,r,nFrames,fOverlap,SigLvl,varargin)
%RRK_Norm Compute the normalized rolling Ripley's K statistic. Reports L as
%percent excess. 
%   Detailed explanation goes here

%% Input Parsing
p = inputParser;

addRequired(p,'pts',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'SigLvl')

addOptional(p,'Mask',[])
addOptional(p,'win',[min(pts(:,1)) max(pts(:,1)) min(pts(:,2)) max(pts(:,2))])

parse(p,pts,r,nFrames,fOverlap,SigLvl,varargin{:});

Mask = p.Results.Mask;
win = p.Results.win;

% adjust win if mask is provided
if ~isempty(Mask)
    [maskheight,maskwidth] = size(Mask);
    win = [0 maskwidth 0 maskheight];
end

%% Compute Observed RK stat
[KObs,KSims,~,FPosition] = RRKSimsMask(pts,r,nFrames,fOverlap,SigLvl,Mask);

% LInv = A./(npts.*(npts-1)); % Inverse lambda (density)
% 
% KObs = bsxfun(@times,EObs,LInv');
% KSims = bsxfun(@times,ESims,LInv');
%% Compute stats and normalize
KMean = mean(KSims,3,'omitnan');
G = log2(KObs./KMean); %Normalized, reports % excess

maxSim = max(KSims,[],3);
minSim = min(KSims,[],3);

Sig = xor(KObs>=maxSim,KObs<=minSim);

% Scale to Range
tgtRange = [-1 1]; % Target range for new min and max Sim value.
KScaled = zeros(nFrames,length(r));
for i = 1:nFrames
    for j =1:length(r)
        KScaled(i,j) = Scale2Range(KObs(i,j),[minSim(i,j) maxSim(i,j)]);
    end
end

Gnan=G;
Gnan(G==-inf|G==inf)=nan;
cLims = [min(Gnan(:),[],'omitnan') max(Gnan(:),[],'omitnan')];

G=G';
Sig = Sig';
KScaled = KScaled';
% LPerc = log2(KObs./KMean);
end

