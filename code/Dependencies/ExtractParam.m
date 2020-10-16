function [param] = ExtractParam(RK,paramname)
%EXTRACTPARAM Extract parameter from RK dataframe. 
%   Detailed explanation goes here
param = [];
for k = 1:numel(RK)
    cparam = RK{k}.(paramname);
    param = [param cparam];
end
end

