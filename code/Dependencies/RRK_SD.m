function [LSD] = RRK_SD(L)
%RRK_SD Compute standard deviation of RRK results
%   Detailed explanation goes here

if iscell(L)
    for k=1:length(L)
    curL = L{k};
    LSD{k} = std(curL,0,3,'omitnan');
    end
else
    
    LSD = std(L,0,3,'omitnan');
end

end