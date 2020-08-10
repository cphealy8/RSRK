function [Pts,ParentPts,ChildPts] = PoissonClusts(Win,ParentNum,ChildNumOpns,ROpns,varargin)
%POISSONCLUSTS Generate aggregated point processes. 
%   Detailed explanation goes here

%% Input parsing
p = inputParser;

addRequired(p,'Win',@isnumeric);
addRequired(p,'ParentNum',@isnumeric);

addRequired(p,'ChildNumOpns',@isnumeric);
addParameter(p,'ChildNumProbs','uniform');

addRequired(p,'ROpns',@isnumeric);
addParameter(p,'RProbs','uniform');

addParameter(p,'AngOpns',[0 2*pi],@isnumeric);
addParameter(p,'AngProbs','uniform');

addParameter(p,'IntensityMap',[],@isnumeric);

parse(p,Win,ParentNum,ChildNumOpns,ROpns,varargin{:});

Res = p.Results;
ChildNumProbs = Res.ChildNumProbs;
RProbs = Res.RProbs;
AngOpns = Res.AngOpns;
AngProbs = Res.AngProbs;
IntensityMap = Res.IntensityMap;

%% Input processing
WinWidth = Win(2)-Win(1);
WinHeight = Win(4)-Win(3);

%% Generate parent points
if ~isempty(IntensityMap)
    ParentPts = PoissonByIntensity(IntensityMap,1,ParentNum);
else
    ParentPts = [WinWidth WinHeight].*rand(ParentNum,2)+...
        repmat([Win(1) Win(3)],[ParentNum 1]); 
end

%% Produce random number of offspring for each parent.
if ischar(ChildNumProbs)
    if strcmp(ChildNumProbs,'uniform')
        ChildNumMin = round(ChildNumOpns(1));
        ChildNumMax = round(ChildNumOpns(2));
        
        % ensure correct range
        if ChildNumMin<0 || ChildNumMax <0 || ChildNumMin>ChildNumMax
            error('Specify ChildNumProbs as [min max]');
        end
        
        % Generate Numbers
        NumChildren = randi([ChildNumMin ChildNumMax],[ParentNum 1]);
        
    elseif strcmp(ChildNumProbs,'normal')
        ChildNumMean = abs(ChildNumOpns(1));
        ChildNumSD = abs(ChildNumOpns(2));
        
        NumChildren = floor(abs(normrnd(ChildNumMean,ChildNumSD,[ParentNum 1])));
    else 
        error('Invalid type for ChildNumProbs')
    end
elseif length(ChildNumProbs)==length(ChildNumOpns)
    NumChildren = randsample(ChildNumOpns,ParentNum,true,ChildNumProbs);
else
    error('A probability must be provided for each entry in ChildNumOpns')
end


%% Specify distances between parents and offspring and compute locations
ChildPts = [];
ChildCenters = repelem(ParentPts,NumChildren,1);
totChildren = sum(NumChildren);

%% Compute distance to cluster for each child
if ischar(RProbs)
    if strcmp(RProbs,'uniform')
        RMin = ROpns(1);
        RMax = ROpns(2);
        
        % ensure correct range
        if RMin<0 || RMax <0 || RMin>RMax
            error('Specify RProbs as [min max]');
        end
        
        % Generate Numbers
        ChildDist = rangeRand([totChildren 1],RMin,RMax);
        
    elseif strcmp(RProbs,'exponential')
        RMean = abs(ROpns(1));
        
        ChildDist = exprnd(RMean,[totChildren 1]);
    else 
        error('Invalid type for RProbs')
    end
elseif length(RProbs)==length(ROpns)
    ChildDist = randsample(ROpns,totChildren,true,RProbs);
else
    error('A probability must be provided for each entry in ROpns')
end

%% Compute angle of each child with respect to center.
if ischar(AngProbs)
    if strcmp(AngProbs,'uniform')
        AngMin = AngOpns(1);
        AngMax = AngOpns(2);
        
        % ensure correct range
        if AngMin<0 || AngMax <0 || AngMin>AngMax
            error('Specify AngProbs as [AngMin AngMax]');
        end
        
        % Generate Numbers
        ChildAng = rangeRand([totChildren 1],AngMin,AngMax);
    else 
        error('Invalid type for AngProbs')
    end
elseif length(AngProbs)==length(AngOpns)
    ChildAng = randsample(AngOpns,totChildren,true,AngProbs);
else
    error('A probability must be provided for each entry in AngOpns')
end

%% Compute Child point locations
ChildPts = [ChildDist.*cos(ChildAng) ChildDist.*sin(ChildAng)]+ChildCenters;
ChildPts = CropPts2Win(ChildPts,Win);

%% Apply Intensity map to ChildPts

Pts = [ChildPts; ParentPts];

end


    
    