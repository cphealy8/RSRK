function [NSTAT] = NeighborStat(ptsA,ptsB,stat,varargin)
%NEIGHBORSTAT Compute various spatial statistics between point processes.
%
%   NEIGHBORSTAT(ptsA,ptsB,'min') Find the minimum distance between each
%   point in point process A (ptsA) and each point in point process B
%   (ptsB). This is the nearest neighbor distance. 
%
%   NEIGHBORSTAT(ptsA,ptsB,'max') Find the maximum distance between each
%   point in point process A (ptsA) and each point in point process B
%   (ptsB).
%
%   NEIGHBORSTAT(ptsA,ptsB,'mean') Find the average distance between each
%   point in point process A (ptsA) and each point in point process B
%   (ptsB). 
%
%   NEIGHBORSTAT(ptsA,ptsB,'median') Find the median distance between each
%   point in point process A (ptsA) and each point in point process B
%   (ptsB). 

D = pairdist(ptsA,ptsB); % Compute the pairwise distance matrix. 
D = sort(D);

switch stat
    case 'min'
        if length(ptsA)==length(ptsB)
            if sum(ptsA(:)~=ptsB(:))==0
                NSTAT = D(2,:);
            else
                NSTAT = D(1,:);
            end
        else 
            NSTAT = D(1,:);
        end
    case 'max'
        NSTAT = D(:,end);
    case 'mean'
        NSTAT = mean(D);
    case 'median'
        NSTAT = median(D);
end

end

