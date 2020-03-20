function [NormRK] = NormalizeRK(RK)
    NormRK = RK;
    NormRK.Obs = log2(RK.Obs./RK.CSR);
    NormRK.CSR = log2(RK.CSR./RK.CSR);
    
    for n = 1:length(RK.Env)
        NormRK.Env = log2(RK.Env./RK.CSR);
    end
end