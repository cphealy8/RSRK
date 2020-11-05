function [param] = ExtractParam(RK,paramname)
%EXTRACTPARAM Extract parameter from RK dataframe. 
%   Detailed explanation goes here
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