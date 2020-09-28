function [LMean] = RRK_Mean(L)
%RRK_MEAN Compute average of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    curL(curL==inf)=NaN;
    curL(curL==-inf)=NaN;
    LMean{k} = mean(curL,3,'omitnan');
    end
else
    LMean(LMean==inf) = NaN;
    LMean(LMean==-inf) = NaN;
    LMean = mean(LMean,3,'omitnan');
end

end