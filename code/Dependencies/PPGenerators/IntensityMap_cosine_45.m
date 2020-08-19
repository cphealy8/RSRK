wWidth = win(2)-win(1);
wHeight = win(4)-win(3);

x = 0:0.01:5;
y = 0:0.01:1;

[xx yy] = meshgrid(x,y);

IMap = 0.5*cos(2*pi*(xx/(x(end))+yy/(y(end))))+0.5;