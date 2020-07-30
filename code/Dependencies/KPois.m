function [K,r,L,KP,LP] = KPois(numpts,win,varargin)
%KPOIS Ripley's K statistic for a randomly generated poisson process(es).
%   KPOIS generates a random placed set or sets of points (as specified by
%   the user) in a window specified by the user then computes the Ripley's
%   K statistic for those points
%
%   [Kxx,r,L] = KPOIS(n,[xmin xmax ymin ymax]) computes the univariate 
%   Ripley's K statistic (Kxx), the scale radius used to compute that 
%   statistic (r), and the L-transform of the K statistic (L) for a random 
%   poisson process of n points in the window xmin to xmax by ymin to ymax. 
%
%   Kxy = KPOIS([n m],win) computes the bivariate Ripley's K statistic 
%   (Kxy) for a pair of random poisson processes of n points and m points in
%   the window defined by win. 
%   
%   K = KPois(n,win,r) computes the Ripley's K statistic using a scale
%   radius defined by the user. 
%
%   SEE ALSO KEST, KESTVAR, KMULTI, and KESTCONF.

nproc = length(numpts); % Number of processes to generate
winDims = [win(2)-win(1) win(4)-win(3)]; % Dimensions of window

% Generate the poisson process(es)
switch nargin 
    case 2 % Default r
        switch nproc 
            case 1 % univariate process
                pts = rand2D(numpts,win);
                [K,r,L] = Kest(pts,win);
            case 2 % bivariate process
                pts1 = rand2D(numpts(1),win);
                pts2 = rand2D(numpts(2),win);
                [K,r,L] = Kmulti(pts1,pts2,win);
        end
    case 3 % User defined r
        r = varargin{1};
        switch nproc
            case 1 % univariate process
                pts = rand2D(numpts,win);
                [K,~,L] = Kest(pts,win,r);
            case 2 % bivariate process
                pts1 = rand2D(numpts(1),win);
                pts2 = rand2D(numpts(2),win);
                [K,~,L] = Kmulti(pts1,pts2,win,r);
        end
end

if nargout >=4 
KP = pi*r.^2; % Theoretical Poisson K. 
LP = r; % Theoretical poisson L. 
end

end

