function [pts] = CropPts2Win(pts,win)
%CROPPTS2WIN Deletes points that fall outside a user defined window. 
%   Detailed explanation goes here
[h,w] = size(pts);

if h==2 && w>2
    pts = pts';
elseif w>2 && h>2
    error('pts must be a 2 column vector')
end

xmin = win(1);
xmax = win(2);
ymin = win(3);
ymax = win(4);

xout = (pts(:,1)<xmin | pts(:,1)>xmax);
yout = (pts(:,2)<ymin | pts(:,2)>ymax);

pts(xout|yout,:) = [];
end

