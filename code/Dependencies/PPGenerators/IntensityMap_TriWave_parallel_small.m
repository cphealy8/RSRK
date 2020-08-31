wWidth = win(2)-win(1);
wHeight = win(4)-win(3);

x = 0:0.01:5;
y = 0:0.01:1;

[xx yy] = meshgrid(x,y);

IMap = (1/2)*sawtooth(2*pi*(xx)/.3125,1/2)+(1/2);

% pcolor(x,y,IMap)
% shading flat
% axis image
% axis(win)