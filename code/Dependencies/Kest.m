function [K,t,L,KP,LP,W,cnt] = Kest(pts,win,varargin)
%KEST Ripley's K estimator
%   [K,t] = KEST(PTS,WIN) computes the Ripley's K statistic of the point
%   process specified by the variable PTS within the rectangular window
%   specified by the variable WIN, with isotropic edge correction enabled.
%   Also outputs the search radii (t) used to compute the K statistic.
%   
%   win = [xmin xmax ymin ymax];
%
%   [K] = KEST(PTS,WIN,t) allows the user to specify their own search radii
%   as a vector. 
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

addRequired(p,'pts',@isnumeric);
addRequired(p,'win',@isnumeric);
addParameter(p,'EdgeCorrection','on',@ischar);
addParameter(p,'t',[],@isnumeric);
addParameter(p,'Mask',[],@isnumeric);

parse(p,pts,win,varargin{:})

EdgeCorrection = p.Results.EdgeCorrection;
t = p.Results.t;
Mask = p.Results.Mask;

% Check pts
[ptsrows,ptscols] = size(pts);
if ptscols==2
    % do nothing the input is correct.
elseif ((ptscols==1 || ptscols>2) && ptsrows==2) % Row column flip
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
[pts]=ignorePts(pts,win);

% apply mask if needed
if ~isempty(Mask)
    pts = CropPts2Mask(pts,Mask);
end

%% Useful numbers
if isempty(Mask)
    A = winL*winW; % Area of the study rectangle.
else 
    A = sum(Mask(:));
end

[Npts,~] = size(pts); % Number of points

%% Compute recommended search radii (t)
if isempty(t)
    tmax = min([winL winW])./2;  % Recommended maximum search radius
    tN = 100;                    % Number of steps in t
    t = linspace(0,tmax,tN);     % Search radii
else
    tN = length(t);
end

t = reshape(t,[1 1 tN]);     % Convert into 3D vector.
%% Compute pairwise euclidean distances
d = pairdist(pts,pts);

%% Compute Indicator function
Ind = bsxfun(@le,d,t);

%% Compute weight
switch EdgeCorrection
    case 'on'
        W=edgeIso(pts,d,win);
    case 'off'
        W=ones(Npts);
end

%% Multiply Id by weight
wInd = bsxfun(@times,Ind,W);

%% Sum for each t to count
% Also minus N to remove the diagonals where i=j (These were false positives)
cnt = sum(sum(wInd,1),2)-Npts;
cnt(cnt<0)=0; % The way we correct for diagonals sometimes incorrectly
              % creates negative counts. Reassign negatives to zero.
%% Compute K
LInv = A/(Npts*(Npts-1)); % Inverse lambda (density)
K = LInv*cnt; % Ripley's K statistic

%% Transform back to 1D vectors
t = reshape(t,[1 tN]);
K = reshape(K,[1 tN]);

%% Compute L transform
if nargout > 2
L= sqrt(K/pi); % Linearizes the K-statistic (for simpler analysis)
end

%% Compute values for poisson process (needed to assess k stat)
if nargout > 3
KP = pi*t.^2; % Theoretical K for poisson point process (totally random)
end

if nargout > 4
LP = sqrt(KP/pi); % Theoretical L for poisson point process (totally random)
end
end

