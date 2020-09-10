function [Result,TestMin,TestMax] = RRK_SDRange(KTarget,KTest,nSD)
%RRK_TTEST2 Compute TTEST2 of KTarget to KTest.
%   Detailed explanation goes here

if iscell(KTarget)
    for k=1:length(KTarget)
    MeanTarget{k} = mean(KTarget{k},3,'omitnan');
    MeanTest{k} = mean(KTest{k},3,'omitnan');
    SDTest{k} = std(KTest{k},0,3,'omitnan');
    
    TestMin{k} = MeanTest{k}-nSD*SDTest{k};
    TestMax{k} = MeanTest{k}+nSD*SDTest{k};
    
    Result{k} = (MeanTarget{k}<=TestMax{k} & MeanTarget{k}>=TestMin{k});
    end
else
    MeanTarget = mean(KTarget,3,'omitnan');
    MeanTest = mean(KTest,3,'omitnan');
    SDTest = std(KTest,0,3,'omitnan');
    
    TestMin = MeanTest-nSD*SDTest;
    TestMax = MeanTest+nSD*SDTest;
    
    Result = (MeanTarget<=TestMax & MeanTarget>=TestMin);
end

end