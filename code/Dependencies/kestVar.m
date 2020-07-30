function [var] = kestVar(numpts,wind,r)
%KESTVAR estimate the variance for Ripley's K.
%   [var] = kestVar(numpts, wind,t) estimates the variance var as a 
%   function of the search radius (t) for the Ripley's K statistic in the 
%   rectangular window specified by wind ([xmin xmax ymin ymax]). The 
%   first argument (numpts) specifies the number of points in the process 
%   for which the variance is being computed. For univariate processes 
%   numpts = n where n is a positive integer. For bivariate processes 
%   numpts = [n m] where n and m are positive integers. 
%
%   See also KEST
width = wind(2)-wind(1);
height = wind(4)-wind(3);

P = 2*width+2*height; % Window perimeter
A = width*height; % Window area

% Compute the constants in the variance estimate. 

v = ((pi*r.^2)/A).*(1-(pi*r.^2/A))+(1.0716*P*r.^3+2.2375*r.^4)/(A^2);
a1 = (0.21*P*r.^3+1.3*r.^4)/A^2;
a2 = (0.24*P*r.^5+2.62*r.^6)/A^3;

type = length(numpts); % 1-Univariate, 2-Bivariate
switch type
    case 1 % univariate
        n = numpts;
%         var = (n-1)*(n^-3)*(A^2)*(2*sigma.^2-alpha1+(n-2)*alpha2);
        var = (A^2)*(2*v-a1+(n-2)*a2)/(n*(n-1));
    case 2 % bivariate
        n = numpts(1);
        m = numpts(2);
        c = (n+(a1/a2-1))/(m+n+2*(a1/a2-1));
        dens = (A/n).*(A/m);
        temp = v-2*c*(1-c)*a1+((m-1)*c^2+(n-1)*((1-c).^2))*a2;
        var = dens*temp;
end

end

