function [P] = RRK_TTest2(KTarget,KTest)
%RRK_TTEST2 Compute TTEST2 of KTarget to KTest.
%   Detailed explanation goes here

if iscell(KTarget)
    for n=1:length(KTarget)
        [~,P{n}] = ttest2(KTarget{n},KTest{n},'Dim',3);
    end
else
    [~,P] = ttest2(KTarget,KTest,'Dim',3);
end

end