function [RK] = PoolRK(type,varargin)
%POOLRK Pool results from RSRK analysis
%   This code pools results from multiple RSRK data files. Running the code
%   will prompt you to select the files you want to pool and output the
%   pooled RSRK data file to a directory that you choose. 

% Create the combined matrix
if nargin == 2
    [RKSamps,x] = CombineRKSamples(varargin);
else
    [RKSamps,x] = CombineRKSamples();
end

if nargin==0
    type='Signal';
end


nSamples = length(RKSamps);
nFrames = length(RKSamps{1});
nr = length(RKSamps{1}{1}.r);
[nsims,~] = size(RKSamps{1}{1}.CSRSims);
for k = 1:nFrames
    pool = allocatePool(nr,nsims,type);
    for n = 1:nSamples
        cRK = RKSamps{n}{k};
        
        % Compute Lambda
        lambda = compLambda(cRK,type);
        
        % Convert RK to E
        [cObsE,cSimE] = RK2E(cRK,lambda);
        
        % Add sample Es to pooled Es.
        pool.ObsE = pool.ObsE + cObsE;
        pool.SimE = pool.SimE + cSimE;
        
        % Sum parameters needed for pooled lambda.
        switch type
            case 'Univariate'
                % Add sample npts and A to pooled npts and A. 
                pool.npts = pool.npts + cRK.npts;
                pool.A = pool.A + cRK.A;
                
            case 'Bivariate'
                % Add sample nptsA, nptsB, and A to pooled nptsA,nptsB, and
                % A.
                pool.nptsA = pool.nptsA + cRK.nptsA;
                pool.nptsB = pool.nptsB + cRK.nptsB;
                pool.A = pool.A + cRK.A;
                
            case 'Signal'
                % Add sample npts, pixTot, and A to pooled npts, pixTot,
                % and A.
                pool.npts = pool.npts + cRK.npts;
                pool.A = pool.A + cRK.A;
                pool.pixTot = pool.pixTot + cRK.pixTot;
        end
        
    end
    % Compute Pooled lambda
    pool.lambda = compLambda(pool,type);
    
    % Using pooled lambda and pooled E compute the pooled RK for the
    % window. (Do this for Observed and CSRsims).
    pool.Obs = pool.ObsE./pool.lambda;
    pool.CSRSims = pool.SimE./pool.lambda;
    
    % Compute the Pooled CSR.
    pool.CSR = mean(pool.CSRSims);
    
    % Compute the Pooled Envelopes
    pool.SigLvls = cRK.SigLvls;
    pool.r = cRK.r;
    r= pool.r;
    % Extract signficance envelopes
for n = 1:length(pool.SigLvls)
    if pool.SigLvls(n)<0
        Inds = ceil(nsims*(-1*pool.SigLvls(n))/2);
    elseif pool.SigLvls(n)>0
        Inds = ceil(nsims*(pool.SigLvls(n))/2);
        Inds = nsims-Inds+1;
    end
        
    pool.Env(n,:) = pool.CSRSims(Inds,:);
end
    
     %%%NEEEED MORE HERE%%%
    % Store as separate windows
    RK{k} = pool;
end

% Save
uisave({'RK','x','r'},'CombinedRK')
end

function [ObsE,SimE] = RK2E(RK,lambda)
    ObsE = lambda*RK.Obs;
    SimE = lambda*RK.CSRSims;
end

function [lambda] = compLambda(pstruct,type)
switch type
    case 'Univariate'
        lambda = pstruct.npts*(pstruct.npts-1)/pstruct.A;
    case 'Bivariate'
        lambda = pstruct.nptsA*pstruct.nptsB/pstruct.A;
    case 'Signal'
        lambda = pstruct.npts*pstruct.pixTot/pstruct.A;
end
end

function [pool] = allocatePool(nr,nsims,type)
pool.ObsE = zeros(1,nr);
pool.SimE = zeros(nsims,nr);
pool.A = 0;

switch type
    case 'Univariate'
        pool.npts = 0;
    case 'Bivariate'
        pool.nptsA = 0;
        pool.nptsB = 0;
    case 'Signal'
        pool.npts = 0;
        pool.pixTot = 0;
end
end