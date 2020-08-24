function [LMin] = RRK_Min(L)
%RRK_MIN Compute min of all RRK results
%   Detailed explanation goes here
if iscell(L)
    for k=1:length(L)
    curL = L{k};
    curLAll = curL(:);
    LMin{k}= min(curLAll);
    end
else
    LAll = L(:);
    LMin = min(LAll,0,3);
end

end