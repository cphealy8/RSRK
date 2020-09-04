x = 1:5;
y = 1:10;

[xx yy] = meshgrid(x,y);
map = xx.*yy;

figure
imagescGrid(x,y,map);  

figure
plot(rand(1,100),rand(1,100),'.r')
