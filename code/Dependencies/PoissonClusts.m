function [Pts,ParentPts,ChildPts] = PoissonClusts(Win,ParentNum,ChildNumOpns,ROpns,varargin)
%POISSONCLUSTS Generate aggregated point processes. 
%   Pts = PoissonClusts(Win,ParentNum,ChildNumOpns,ROpns) generates a point
%   process under poisson clustering in the window defined by win = [xmin
%   xmax ymin ymax]; ParentNum defines the number of parent points (or
%   clusters) distributed according to a poisson process. ChildNumOpns is a
%   vector that defines the number options for number of children for each
%   parent. ROpns defines the options for the distance each child can be
%   from it's parent. 
%
%   By default poisson clusts randomly select the number of children,
%   distance from parent, and angle with respect to parent from a uniform
%   distribution. However, additional inputs can be provided to use
%   different distributions.
%
%   PoissonClusts(Win,ParentNum,[mu SD],ROpns,'ChildNumProbs','Normal')
%   generates poisson clusters with a number of children points selected
%   from a normal distribution with mean mu and standard deviation SD
%   defined in ChildNumOpns =[mu SD];
%
%   PoissonClusts(Win,ParentNum,[min max],ROpns,'ChildNumProbs','Uniform')
%   generates poisson clusters with a number of children points selected
%   from a uniform distribution defined between the argumens min and max.
%   
%   PoissonClusts(Win,ParentNum,[n1 n2 ... nn],ROpns,'ChildNumProbs',[p1 p2
%   ... pn] generates poisson clusters with a number of children (specified
%   by the vector [n1 n2 ... nn] at user defined probabilities [p1 p2 ...
%   pn]. 
%
%   PoissonClust(Win,ParentNum,ChildNumOpns,[rmin rmax],'RProbs','uniform')
%   generates poisson clusters with children spaced away from their parents
%   according to a uniform distribution defined between rmin and rmax.
%
%   PoissonClust(Win,ParentNum,ChildNumOpns,[mu],'RProbs','exponential'
%   generates poisson clusters with children spaced away from their parents
%   according to a exponential distribution with mean mu. 
%
%   PoissonClust(Win,ParentNum,ChildNumOpns,ROpns,'AngProbs','uniform','AngOpns',[angmin
%   angmax] generates poisson clusters with children angled from their
%   parents according to a uniform distribution defined between angmin and
%   angmax. Units are in radians.
%
%   As with ChildNumProbs user defined probability distributions can also 
%   be used to define child to parent angles by passing a vector of angs in
%   AngOpns and a probability for each distance for 'AngProbs'.
%
%   PoissonClust(Win,ParentNum,ChildNumOpns,ROpns,'IntensityMap',IMap)
%   generates an inhomogenous poisson cluster process where the intensity
%   of point process is defined by the input matrix IMAP. Imap should be a
%   vector that defines the intensity of the point process at a given
%   location spanning the window defined by win. 
% 
%   SEE ALSO POISSONBYINTENSITY and THINBYINTENSITY.
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

%% Generate parent 
if numel(ParentNum)==1
    if ~isempty(IntensityMap)
        [xpix,ypix] = size(IntensityMap);
        xscale = xpix/WinWidth;
        yscale = ypix/WinHeight;

        ParentPts = PoissonByIntensity(IntensityMap,1,ParentNum)./[xscale yscale];
    else
        ParentPts = [WinWidth WinHeight].*rand(ParentNum,2)+...
            repmat([Win(1) Win(3)],[ParentNum 1]); 
    end
elseif ismember(2,size(rand(2,100)))
    ParentPts = ParentNum;
    ParentNum = length(ParentPts);
else
    error('Invalid input type for ParentNum')
end

%% Produce random number of offspring for each parent.
if ischar(ChildNumProbs)
    if strcmp(ChildNumProbs,'uniform')
        if numel(ChildNumOpns)==1
            NumChildren = ones(ParentNum,1)*ChildNumOpns;
        else
            ChildNumMin = round(ChildNumOpns(1));
            ChildNumMax = round(ChildNumOpns(2));

            % ensure correct range
            if ChildNumMin<0 || ChildNumMax <0 || ChildNumMin>ChildNumMax
                error('Specify ChildNumProbs as [min max]');
            end

            % Generate Numbers
            NumChildren = randi([ChildNumMin ChildNumMax],[ParentNum 1]);
        end
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
if ~isempty(IntensityMap)
    ChildPts = ThinByIntensity(IntensityMap,Win,ChildPts);
end

Pts = [ChildPts; ParentPts];

end


    
    