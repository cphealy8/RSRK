function [LMean] = RRK_Mean(L)
%RRK_MEAN Compute average of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LMean{k} = mean(curL,3);
    end
else
    LMean = mean(curL,3);
end

end