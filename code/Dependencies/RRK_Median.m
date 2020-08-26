function [LMedian] = RRK_Median(L)
%RRK_MEDIAN Compute median of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LMedian{k} = median(curL,3,'omitnan');
    end
else
    LMedian = median(curL,3,'omitnan');
end

end