function [PercEx,G,Sig,alpha] = RRKSigStandard(KObs,KSims,varargin)
%RRKSigStandard Compute standardized RRK stats using observed and simulated RRK
%values. 
%   [PercEx,G,Sig,KSimsMean] = RRKSigStandard(KObs,KSims) computes the
%   percent excess number of points in KObs over the mean of KSims
%   (PercEx). Also reports G, the fold difference between the Observed K
%   statistic and the mean of KSims. Finally, determines whether KObs falls
%   within the significance envelope defined by KSims. Reports whether KObs
%   is significant (1) or is not significant (0) in the output matrix Sig.

p = inputParser;

addRequired(p,'KObs',@isnumeric)
addRequired(p,'KSims',@isnumeric)
addOptional(p,'alpha',1e-3,@isnumeric)

parse(p,KObs,KSims,varargin{:})

alpha = p.Results.alpha;
%%
if size(KSims,1)~=size(KObs,1)
        KObs = KObs';
        if size(KSims,1)~=size(KObs,1)
            error('Matrix dimensions of KSims and KObs must agree');
        end
end
    
if size(KObs,3)==1
    nsims = size(KSims,3);
    alpha = 2/(nsims+1);
    
    KSimsMean = mean(KSims,3,'omitnan');

    KRatio = KObs./KSimsMean;

    maxSim = max(KSims,[],3);
    minSim = min(KSims,[],3);

    Sig = xor(KObs>=maxSim,KObs<=minSim);
elseif size(KObs,3)>1
    KObsMean = mean(KObs,3);
    KSimsMean = mean(KSims,3);
    
    KRatio = KObsMean./KSimsMean;
    [~,Sig] = RRK_TTest2(KObs,KSims,alpha);
end

PercEx = KRatio-1; % Report percent excess
G = log2(KRatio); %Normalized, fold excess

end


