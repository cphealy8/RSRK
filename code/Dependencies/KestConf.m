function [UpperConf,LowerConf] = KestConf(npts,win,t,KP,ConfLevel,type)
%KESTCONF Compute confidence intervals for Ripley's K. 
% npts - specified as a scalar for one point process or a 1x2 vector for two
% point processes.
% ----Inputs----
% win - the window dimensions specified as [xmin xmax ymin ymax];
% t - vector of search radii.
% KP - K statistic for the poisson distribution (this is an output of
%      Kest).
% ConfLevel - Confidence level specified as a decimal e.g. 99% = 0.99
% type - type of transform applied to the confidence intervals. The options
%        are 'K' for standard Ripley's K, 'L' for the L-transform which
%        which linearizes K, and 'L-t' for the L-transform minus the
%        search radius (t) which reduces CSR to a horizontal line running
%        through zero. The 'L-t' transform is the most commonly used. 
% ----Outputs----
% UpperConf - the upper confidence interval for the confidence level
%             desired specified as a vector with the same length as t. 
% LowerConf - the lower confidence interval for the confidence level
%             desired specified as a vector with the same lenght as t. 

% compute variance in ripley's K
var = kestVar(npts,win,t);
sd = sqrt(var); 

% Compute upper and lower confidence intervals
zc = norminv(ConfLevel + (1-ConfLevel)/2); % Critical value

% Default is untransformed or (K) type. 
UpperConf = KP+zc*sd;
LowerConf = KP-zc*sd;

% Apply other transforms if desired;
if strcmp(type,'K')
    % do nothing;
elseif strcmp(type,'L') % L-transform
    UpperConf = sqrt(UpperConf/pi);
    LowerConf = sqrt(LowerConf/pi);
elseif strcmp(type,'L-t')% L-t transform
    UpperConf = sqrt(UpperConf/pi)-t;
    LowerConf = sqrt(LowerConf/pi)-t;
else
    error('Unrecognized type requested')
end

end

