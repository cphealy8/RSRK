function [xscaled] = Scale2Range(x,limsIn,varargin)
%Scale2Range scale and shift an input vector to fit a specified range.
%   [xscaled] = SCALE2RANGE(x,[1 10]) scales the values in the input vector
%   such that x=1 is rescaled and shifted to -1 and x=10 is rescaled and
%   shifted to +1. All others are scaled and shifted proportionally. 
%
%   [xscaled] = SCALE2RANGE(x,[1 10],[0 1]) scales the values in the input
%   vector x such that x=1 is rescaled and shifted to 0 and x=10 is scaled
%   and shifted to 1. All other values in x are scaled proportionally.
%
%   AUTHOR: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah. 
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

