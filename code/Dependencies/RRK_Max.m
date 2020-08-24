function [LMax] = RRK_Max(L)
%RRK_MAX Compute max of all RRK results
%   Detailed explanation goes here
if iscell(L)
    for k=1:length(L)
    curL = L{k};
    curLAll = curL(:);
    LMax{k}= max(curLAll);
    end
else
    LAll = L(:);
    LMax = max(LAll,0,3);
end

end