function [coords] = makeCoord(coords,dim)
%ISCOORD Impose consistent format for coordinates. 
%   [coordOut] = MAKECOORD(coordIn,dim) takes a coordinate matrix and
%   forces it to adopt the format where each row indicates a coordinate and
%   each column specifies a dimension of the coordinate. Additionally
%   checks if the coordinates are appropriate for the specified number of 
%   dimensions in the coordinate system (dim). 

ptsz = size(coords);

if numel(ptsz)~=dim
    error('Input coordinates do not match the specified number of dimensions')
end

if ptsz(2)>ptsz(1)
    % The format is likely flipped. 
    coords = coords';
elseif ptsz(2)==ptsz(1)
    warning('Coordinate orientation could not be determined. Nothing was changed')
end        

end

