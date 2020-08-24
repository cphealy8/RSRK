load('..\..\data\Verification Tests\Random Homogenous.mat')
Lmean=(RRK_Mean(L));
LSD = RRK_SD(L);
LMedian = RRK_Median(L);
LMAD = RRK_MAD(L);
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

function [LSD] = RRK_SD(L)
%RRK_SD Compute standard deviation of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LSD{k} = std(curL,0,3);
    end
else
    LSD = std(curL,0,3);
end

end


function [LMedian] = RRK_Median(L)
%RRK_MEDIAN Compute median of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LMedian{k} = median(curL,3);
    end
else
    LMedian = median(curL,3);
end

end

function [LMAD] = RRK_MAD(L)
%RRK_MEDIAN Compute median of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LMAD{k}= mad(curL,0,3);
    end
else
    LMAD = mad(curL,0,3);
end

end
