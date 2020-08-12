function [pts] = InhibitionPP(Win,PkgDens,InhDist,varargin)
%INHIBITIONPP Generate uniform point process via simple inhibition.
%   [pts] = InhibitionPP(Win,PkgDens,InhDist) generate a uniform process in
%   the window defined by Win = [xmin xmax ymin ymax] with a packing
%   Density given by PkgDens and Inhibition Distance given by InhDist. 
%
%   [pts] = InhibitionPP(Win,PkgDens,InhDist,'IntensityMap',IMap) generate
%   a inhomogenous uniform point process. Inhomogeneity is introduced via
%   the intensity map IMAP.
%
%   [pts] = InhibitionPP(Win,PkgDens,InhDist,'MaxReps',MaxReps) set the
%   maximum number of repetitions to use when generating the point process.
%   Default MaxReps is 10. 
%
%   SEE ALSO POISSONCLUSTS and POISSONBYINTENSITY.
p = inputParser;

addRequired(p,'Win',@isnumeric);
addRequired(p,'PkgDens',@isnumeric);
addRequired(p,'InhDist',@isnumeric);
addParameter(p,'IntensityMap',[],@isnumeric);
addParameter(p,'MaxReps',20,@isnumeric);

parse(p,Win,PkgDens,InhDist,varargin{:})

WinWidth = Win(2)-Win(1);
WinHeight = Win(4)-Win(3);
Area = WinWidth*WinHeight;

MaxReps = p.Results.MaxReps;
IntensityMap = p.Results.IntensityMap;

%% Generate poisson process
maxPkgDens = 0.547;
maxN = ceil(4*Area*maxPkgDens/(pi*(InhDist^2)));
Npts = ceil(4*Area*PkgDens/(pi*(InhDist^2)));
pts = [rangeRand([maxN 1],Win(1),Win(2)) rangeRand([maxN 1],Win(3),Win(4))];

% Check PackingDensity
if PkgDens>maxPkgDens
    warning(sprintf('PkgDens cannot exceed %1.3f.',maxPkgDens));
end

% Handle case of large inhibition distance.
if InhDist>sqrt((WinWidth^2)+(WinHeight^2))
    warning('Inhibition distance exceeds maximum window dimension. Only one point generated');
    pts(2:end,:) = [];
    return
end

reps = 0;
while true
    reps = reps+1;
% Compute pairdist matrix
ppDists = pairdist(pts,pts);
ppDists = ppDists + diag(NaN(length(pts),1)); % correct diagonal

WithinInhDist = ppDists<InhDist;

% Determine which points to delete.
for n=1:maxN
     progenitors = WithinInhDist(n,n:end);
     if sum(progenitors)~=0
         DoDelete(n) = true;
     else
         DoDelete(n) = false;
     end
end

% Delete points
pts(DoDelete',:) = [];

% Check and correct number of points.
curN = length(pts); 

delN = curN-Npts;

if delN>0 % delete excess points
    excess = randsample(curN,delN);
    pts(excess,:) = [];
    break
elseif reps>MaxReps
    warning('Maximum repetitions reached before attaining specified packing density');
    break
end

newpts = [rangeRand([maxN 1],Win(1),Win(2)) rangeRand([maxN 1],Win(3),Win(4))];
    pts = [newpts; pts];

end

%% Apply Intensity Map if defined
if ~isempty(IntensityMap)
    pts = ThinByIntensity(IntensityMap,Win,pts);
end

end

