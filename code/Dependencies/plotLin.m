function [h] = plotLin(direction,value,varargin)
%PLOTLIN Plot a horizontal or vertical line.
%   [h] = PLOTLIN('v',1,'-r') plots a vertical line that intersects the 
%   x-axis at x = 1 and returns the handle for the line h.
% 
%   [h] = PLOTLIN('h',3,'--b') plots a horizontal dashed blue line that 
%   intersects the y-axis at y = 3.
%
%   See also PLOT, REFLINE.
%
%   Version 1.0
%
%   Author: Connor Healy, connor.healy@utah.edu

switch direction
    case 'v'
        y1 = get(gca,'ylim');
        h = plot([value value],y1,varargin{:});
    case 'h'
        x1 = get(gca,'xlim');
        h = plot(x1,[value value],varargin{:});
end

end

