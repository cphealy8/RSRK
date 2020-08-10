function [Pts,ParentPts,ChildPts] = PoissonClusts(Win,ParentNum,ChildOpns,ROpns,varargin)
%POISSONCLUSTS Generate aggregated point processes. 
%   Detailed explanation goes here

%% Input parsing
p = inputParser;

addRequired(p,'Win',@isnumeric);
addRequired(p,'ParentNum',@isnumeric);
addRequired(p,'ChildOpns',@isnumeric);
addRequired(p,'ROpns',@isnumeric);
addParameter(p,'ChildProbs',[],@isnumeric);
addParameter(p,'RProbs','uniform');
addParameter(p,'AngOpns',[0 2*pi]);
addParameter(p,'AngProbs','uniform');
addParameter(p,'IntensityMap',[],@isnumeric);

parse(p,Win,ParentNum,ChildOpns,ROpns,varargin{:});

Res = p.Results;
ChildProbs = Res.ChildProbs;
RProbs = Res.RProbs;
AngOpns = Res.AngOpns;
AngProbs = Res.AngProbs;
IntensityMap = Res.IntensityMap;

% Check inputs
if isempty(ChildProbs)
    ChildProbs = ones(1,length(ChildOpns))/length(ChildOpns);
end

if length(ChildProbs)~=length(ChildOpns)
    error('A probability must be provided for each number of children')
end

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
NumChildren = randsample(ChildOpns,ParentNum,true,ChildProbs);

%% Specify distances between parents and offspring and compute locations
ChildPts = [];
for k =1:ParentNum
    
    dr = randsample(ROpns,NumChildren(k),true,RProbs)';
    theta = randsample(AngOpns,NumChildren(k),true,AngProbs)';
    
    dx = dr.*cos(theta);
    dy = dr.*sin(theta);
    
    newChildren = ParentPts(k,:)+[dx dy];
    ChildPts = [ChildPts; newChildren];
end
ChildPts = CropPts2Win(ChildPts,Win);


end


    
    