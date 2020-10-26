function [K,t,L,KP,LP,wAB,cnt] = Kmulti(ptsA,ptsB,win,varargin)
%KMULTI Bivariate Ripley's K estimator
%   [K,t] = KMULTI(ptsA,ptsB,Win) computes the bivariate Ripley's K
%   statistic (K) between the two point processes specified by the inputs 
%   ptsA and ptsB within the window specified by the input win 
%   (win = [xmin xmax ymin ymax]) over the search radius t. 
%
%   Ripleys K(t) function is a tool for analyzing completely mapped spatial
%   (2D) point process data. It describes characteristics at many distance
%   scales specified by the search radius t. It can distinguish randomly 
%   distributed point processes from point processes with clustering and
%   point processes with dispersion. [1]
%   
%   -----ADDITIONAL OUTPUTS-----
%   [~,~,L] = KEST(PTS,WIN) computes the L-transform of the Ripley's K
%   statistic. The L transform is a normalization of K(t) to a homogenously
%   distributed Poisson point process (entirely random) and is commonly
%   used to analyze the K statistic. [1]
%
%   [~,~,~,KP,LP] = KEST(PTS,WIN) outputs the theoretical K and L statistics,
%   KP and LP respectively, for a random Poisson process in the window
%   specified by the variable WIN. This is useful for graphical 
%   comparisons of K and L to entirely random processes. Note KP=p*t^2 and
%   LP = t where t is the search radius used to compute the K statistic.
%
%   [~,~,~,~,W] = KEST(PTS,WIN) outputs the weight term (wij) used in the
%   edge correction. 
%
%   -----ADDITIONAL INFORMATION-----
%   Future versions of KEST will permit variable arguments to specify the
%   search radius (t) and edge correction (w) used in computing K(t).
%
%   References
%   1. P. M. Dixon, Ripley’s K function. Encycl. Environmetrics. 3, 
%      1796–1803 (2002).
%
%   See also PAIRDIST, EDGEISO.

%% Check/correct incorrect inputs

p = inputParser;

addRequired(p,'ptsA',@isnumeric)
addRequired(p,'ptsB',@isnumeric)
addRequired(p,'win',@isnumeric)
addOptional(p,'t',[],@isnumeric)
addOptional(p,'Mask',[],@isnumeric)

parse(p,ptsA,ptsB,win,varargin{:})

t = p.Results.t;
Mask = p.Results.Mask;



% Check ptsA
[ptsrowsA,ptscolsA] = size(ptsA);
if ptscolsA==2
    % do nothing the input is correct.
elseif ((ptscolsA==1 || ptscolsA>2) && ptsrowsA==2) % Row column flip
    pts = pts'; % Transpose the pts matrix.
else 
    error('pts must be an N-by-2 column matrix')
end

% Check ptsB
[ptsrowsB,ptscolsB] = size(ptsB);
if ptscolsA==2
    % do nothing the input is correct.
elseif ((ptscolsB==1 || ptscolsB>2) && ptsrowsB==2) % Row column flip
    pts = pts'; % Transpose the pts matrix.
else 
    error('pts must be an N-by-2 column matrix')
end

% Check win
[wrows,wcols] = size(win);

if wrows==4 && wcols==1 % Row column flip
    win = win'; % Transpose the win vector.
elseif wrows*wcols~=4 % Too many, too few dimensions specified
    error('win must be a 1-by-4 vector of the form [xmin xmax ymin ymax].')
end

winL = diff(win(1:2));       % window length
winW = diff(win(3:4));       % window width

if winL <= 0 || winW<=0 % window does not specify a rectangle
    error('win must specify a rectangular window of the form [xmin xmax ymin ymax]')
end


%% Ignore points outside the window
[ptsA]=ignorePts(ptsA,win);
[ptsB]=ignorePts(ptsB,win);

% apply mask to pts if needed.
if ~isempty(Mask)
    ptsA = CropPts2Mask(ptsA,Mask);
    ptsB = CropPTs2Mask(ptsB,Mask);
end

%% Useful info
% Size
[N,~]=size(ptsA);
[M,~]=size(ptsB);

winL = diff(win(1:2));       % window length
winW = diff(win(3:4));       % window width

% Window Area
if isempty(Mask)
    area = winL*winW;               
else
    area = sum(Mask(:));
end

%% Compute recommended search radii (t)
if isempty(t)
tmax = min([winL winW])./2;  % Recommended maximum search radius
tN = 100;                    % Number of steps in t
t = linspace(0,tmax,tN);     % Search radii
elseif ~isempty(t)
    tN = length(t);
end
t = reshape(t,[1 1 tN]);     % Convert into 3D vector.

%% Pairwise distance
d = pairdist(ptsA,ptsB);

%% Compute Indicator function
Ind = bsxfun(@le,d,t);

%% Compute weight
Cat = [ptsA; ptsB]; % Concatenate the points together
wCat = edgeIso(Cat,pairdist(Cat,Cat),win); % Compute the collective weights

% wCat contains the weight matrices for comparing A to B we just have to
% extrac it.
wAB = wCat(1:N,N+1:end); % Weight for A to B comparison, size NxM.

%% Multiply Id by combined weight
wInd = bsxfun(@times,Ind,wAB);
%% Sum for each t to count
% Also minus N to remove the diagonals where i=j (These were false positives)
cnt = sum(sum(wInd,1),2);

%% Compute K
LInv = area/(N*M); % Inverse lambda (density)
K = LInv*cnt; % Ripley's K statistic

%% Transform back to 1D vectors
t = reshape(t,[1 tN]);
K = reshape(K,[1 tN]);

%% Compute L transform
L= sqrt(K/pi); % Linearizes the K-statistic (for simpler analysis)

%% Compute values for poisson process (needed to assess k stat)
KP = pi*t.^2; % Theoretical K for poisson point process (totally random)
LP = sqrt(KP/pi); % Theoretical L for poisson point process (totally random)
end

