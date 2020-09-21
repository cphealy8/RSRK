function [scanmap] = RKScanner(im,pts,r)
[nRows, nCols] = size(im'); % Determine size of input mat
x = 1:nRows;
y = 1:nCols;

[xx, yy] = meshgrid(x,y); % Determine grid points
nr = length(r); % Number of radii
npts = length(pts); % Number of points

% Initialize
scanmap = zeros(nCols,nRows,nr);

cnt = 0;

if numel(pts)==2
        npts = 1;
end

for k=1:nr
    tempmap = zeros(nRows,nCols);
    
    for n=1:npts
        
    nthCirc = sqrt((xx-pts(n,1)).^2 + ...
                      (yy-pts(n,2)).^2) <= r(k);
    tempmap = tempmap+nthCirc';
    end
    scanmap(:,:,k) = tempmap';
end