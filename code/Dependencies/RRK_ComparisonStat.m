function [stat,G,P] = RRK_ComparisonStat(KTarget,KTest)
%RRK_ComparisonStat Stat for comparing RRK statistics. Combines TTest2 and
%log2norm. 
%
%   SEE ALSO RRK_LOG2NORM and RRK_TTEST2.
%   Detailed explanation goes here
if iscell(KTarget)
    for n=1:length(KTarget)
        G{n} = mean(Log2Norm(KTarget{n},KTest{n}),3);
        [~,P{n}] = ttest2(KTarget{n},KTest{n},'Dim',3);
        stat{n} = (1-P{n}).*sign(G{n});
    end
else
    G = mean(Log2Norm(KTarget,KTest),3);
    [~,P] = ttest2(KTarget,KTest,'Dim',3);
    stat = (1-P).*sign(G);
end

end
function [G] = Log2Norm(KNum,KDenom)
    G = log2(KNum./KDenom);
end