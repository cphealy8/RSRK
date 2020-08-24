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