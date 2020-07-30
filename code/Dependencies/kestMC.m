function [UE,LE] = kestMC(npts,win,r,confLevel,TransType,varargin)
%kestMC Ripley's K confidence intervals using Monte-Carlo simulation.
%   [UE,LE] = kestMC(npts,win,r,confLevel,TransType) computes the upper 
%   envelope (UE) and lower envelope (LE) for ripleys K at a specified 
%   confidence level(s) (confLevel) for n points (npts) in a window(win)
%   e.g. win = [xmin xmax ymin ymax], for a vector of search radii(r). The
%   5th argument (TransType) specifies the the type of transformation
%   applied to the envelopes. Acceptable inputs for TransType include
%        TransType = 'K'; for untransformed Ripley's K
%        TransType = 'L'; for the L-transformation which linearizes
%                         Ripley's K e.g. L=sqrt(K/pi);
%        TransType = 'L-r'; for the L-transformation of Ripley's K minus
%                           r. This linearizes Ripley's K then zeros CSR
%                           making for very simple interpretation. 
%
%   Note for bivariate Ripley's K npts should be a 1x2 vector specifying
%   the number of points in each process e.g. npts = [n m] for comparison
%   of a process containing n points and another process containing m
%   points. 
%
%   An optional 5th argument (nsims) can be used to specify the desired
%   number of simulations though the default is recommended. 
h = waitbar(0,'Computing Confidence Envelopes');

% Perform the simulations
nsims = 999; % Default number of simulations.

% If user specifies a number of simulations.
if ~isempty(varargin)
    nsims = varargin{1}; 
end

K = zeros(nsims,length(r)); % preallocate

for n = 1:nsims
    tic
    K(n,:) = KPois(npts,win,r);
    simtime = toc;
    waitbar(n/nsims,h,sprintf('Time Remaining: %1.0f min',simtime*(nsims-n)/60));
    
end

% Set confidence indices
% The width of the intervals on either side (in indices) for the set number
% of simulations and the set confidence level. Ceil is used to ensure that
% the actual confidence level is equal to or greater than the input
% confidence level (this has to do with roundoff error).
indW = ceil((nsims+1)*(1-confLevel)/2);
switch TransType
    case 'K'
        statvec = K;
    case 'L'
        statvec = sqrt(K/pi);
    case 'L-r'
        statvec = sqrt(K/pi)-r;
end

% Sort the results by column.
sortvec = sort(statvec);

% Select the upper indWth and lower indWth values to set as the upper and
% lower confidence intervals/envelopes.

for n = 1:length(indW)
LE(:,n) = sortvec(indW(n),:);       % Lower confidence envelope
UE(:,n) = sortvec(end-indW(n)+1,:); % Upper confidence envelope. 
end

delete(h);
end