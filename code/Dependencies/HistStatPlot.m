function [aH] = HistStatPlot(data,varargin)
%HISTSTATPLOT Plot histogram of input data with statistic overlay.
%   HistStatPlot(data) generates a histogram of the input data vector and
%   overlays the mean+-SD and median as overlay using PDF normalization and
%   the Freedman Diaconis Rule for the number of bins.
%
%   HISTSTATPLOT(data,'StatType','Median',...) instead overlays the median, first-quartile
%   Q1, third quartile Q3, and mean of the input data.
%
%   HISTSTATPLOT(data,'Normalization',normalizationtype,...) specify the
%   type of normalization used. See documentation on HISTOGRAM for valid
%   normalization types.
%
%   HISTSTATPLOT(data,'BinDatRange',[minquant maxquant]) define the minimum
%   and maximum bin values expressed as quantiles of the data e.g. [0.25
%   0.75] would restict the bin range to the IQR of the input data.
%
%   HISTSTATPLOT(data,'nbins',NBins) specify the number of bins to use. By
%   default the number of bins is equal to half those recommended under the
%   Freedman-Diaconis rule.
%
%   See also HISTOGRAM.
%
%   Author: Connor P. Healy, University of Utah. (connor.healy@utah.edu)
%   Last Updated: 11-30-2020
%   Version: 1.00

p = inputParser;
addRequired(p,'data',@isnumeric);

validTypes = {'Mean','Median'};
checkType = @(x) any(validatestring(x,validTypes));
addOptional(p,'StatType','Mean',checkType)

addOptional(p,'Normalization','PDF',@ischar);
addOptional(p,'BinDatRange',[0.001 0.999],@isnumeric);
addOptional(p,'nbins',[],@isnumeric)

parse(p,data,varargin{:});

StatType = p.Results.StatType;
BinQntRange = p.Results.BinDatRange;
Normalization = p.Results.Normalization;
nbins = p.Results.nbins;

nobs = numel(data);
binRange = quantile(data,BinQntRange);

if isempty(nbins)
    h=2*iqr(data)*(nobs^(-1/3)); % freedman-diaconis rule
    nbins = round(abs(diff(binRange))/(2*h));
end

%% Plot
binEdges = linspace(binRange(1),binRange(2),nbins);

aH = histogram(data,binEdges,...
    'Normalization',Normalization,...
    'EdgeColor','none','FaceColor',[0.5 0.5,0.5]);
hold on
meandat = mean(data(:));
meddat = median(data(:));

lwd=1.5;
switch StatType
    case 'Mean'
        xline(meandat,'-r','LineWidth',lwd)
        sddat = std(data(:));
        xline(meandat+sddat,'--r','LineWidth',lwd)
        xline(meandat-sddat,'--r','LineWidth',lwd)
        xline(meddat,':b','LineWidth',lwd)
        
        legend('Data',...
            sprintf('Mean: %1.1f',meandat),...
            sprintf('+SD: %1.1f',meandat+sddat),...
            sprintf('-SD: %1.1f',meandat-sddat),...
            sprintf('Median: %1.1f',meddat));
    case 'Median'
        xline(meddat,'-b','LineWidth',lwd)
        Q1 = quantile(data,0.25);
        Q3 = quantile(data,0.75);
        xline(Q1,'--b','LineWidth',lwd)
        xline(Q3,'--b','LineWidth',lwd)
        xline(meandat,':r','LineWidth',lwd)
        
        legend('Data',...
            sprintf('Median: %1.1f',meddat),...
            sprintf('Q1: %1.1f',Q1),...
            sprintf('Q3: %1.1f',Q3),...
            sprintf('Mean: %1.1f',meandat));
end

end