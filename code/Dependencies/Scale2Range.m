function [xscaled] = Scale2Range(x,limsIn,varargin)
%Scale2Range Summary of this function goes here
%   Detailed explanation goes here
%% Parse inputs
p = inputParser;
addRequired(p,'x',@isnumeric)
addRequired(p,'limsIn',@isnumeric)
addOptional(p,'limsOut',[-1 1],@isnumeric)

parse(p,x,limsIn,varargin{:})

limsOut = p.Results.limsOut;

%% Scale the values
minr = limsIn(1);
maxr = limsIn(2);

midr = mean(limsOut);

rangeOut = diff(limsOut);
rangeIn = diff(limsIn);

scale = rangeOut/rangeIn;

minScaled = minr*scale;
maxScaled = maxr*scale;

% if rangeIn==0
%     shift = midr-maxr;
%     xscaled = x+shift;
% else
    shift = -minScaled+limsOut(1);
    xscaled = x.*scale+shift;
% end



end

