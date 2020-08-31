function [G] = RRK_Log2Norm(KTarget,KTest)
%RRK_LOG2NORM Compute log2 of KTarget normalized to KTest.
%   Detailed explanation goes here

if iscell(KTarget)
    for n=1:length(KTarget)
        G{n} = Log2Norm(KTarget{n},KTest{n});
    end
else
    G = Log2Norm(KTarget,KTest);
end

end

function [G] = Log2Norm(KNum,KDenom)
    G = log2(KNum./KDenom);
    G(G==-inf)=NaN;
end


