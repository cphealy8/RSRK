function [LowerConf,UpperConf,test] = RRK_ConfInt(KCSR,SigLvl,varargin)
%RRK_CONFINT Compute confidence intervals for RRK and RSRK results
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'KCSR')
addRequired(p,'SigLvl')
addOptional(p,'KOBS',[])

parse(p,KCSR,SigLvl,varargin{:});
KOBS = p.Results.KOBS;
%%
if iscell(KCSR)
    for k=1:length(KCSR)
    curK = KCSR{k};
    curK(curK==inf)=NaN;
    curK(curK==-inf)=NaN;

    [LowerConf{k},UpperConf{k}] = FindConfIJ(curK,SigLvl);
    
%     if ~isempty(KOBS)
%         T{K} = 
%     else 
%         T=[];
%     end
else
    KCSR(KCSR==inf) = NaN;
    KCSR(KCSR==-inf) = NaN;
    
    [LowerConf,UpperConf] = FindConfIJ(KCSR,SigLvl);
end
end

function [LowerConf,UpperConf] =FindConfIJ(curK,SigLvl)
    [nrow, ncol, nreps] = size(curK);
    LowerConf = zeros(nrow,ncol);
    UpperConf = zeros(nrow,ncol);
    
    for i = 1:nrow
        for j= 1:ncol
            Kij = curK(i,j,:);
            [LowerConf(i,j),UpperConf(i,j)]=FindConf(Kij,SigLvl);
        end
    end
end

function [LowerConf,UpperConf] = FindConf(K,SigLvl)
K(isnan(K))=[];
KSort = sort(K,'ascend');
lowSigID = round(length(K)*SigLvl);
uppSigID = round(length(K)*(1-SigLvl));

LowerConf = KSort(lowSigID);
UpperConf = KSort(uppSigID);
end

