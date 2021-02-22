function [param] = ExtractParam(RK,paramname)
%EXTRACTPARAM Extract parameter from RK dataframe. 
%   Isolate a desired parameter from an RSRK dataframe e.g. 
%   pts = ExtractParam(RK,'pts') isolates the variable named 'pts' stored
%   in the RK dataframe (e.g. RK.pts) and outputs it. 
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   Affiliation: Dept. of Biomedical Engineering, University of Utah.
%%
param = [];
for k = 1:numel(RK)
    cparam = RK{k}.(paramname);
    if numel(size(cparam))==1
        param = [param cparam];
    elseif numel(size(cparam))==2
        param(k,:,:) = cparam';
    end
end
end