function [ConfRng,upInt,lowInt] = quickConfInt(data,varargin)
%quickConfInt Compute quick confidence interval around data mean. 
%   Detailed explanation goes here
p = inputParser;

addRequired(p,'data',@isnumeric)
addOptional(p,'alpha',0.05,@isnumeric)
addOptional(p,'df',[],@isnumeric);

parse(p,data,varargin{:});

alpha = p.Results.alpha;
df = p.Results.df;

N = numel(data);
if isempty(df)
    df = N-1;
end

ySEM= std(data)./sqrt(N);
CI95 = tinv([alpha/2 1-(alpha/2)],df);
yCI95 = bsxfun(@times,ySEM,CI95(:));
meanY = mean(data);


ConfRng = yCI95(2);
upInt = meanY+ConfRng;
lowInt = meanY-ConfRng;
end

