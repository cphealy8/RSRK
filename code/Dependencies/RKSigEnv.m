function [RK] = RKSigEnv(im,pts,r,mask,SigLvls,CompType,varargin)
%RKSIGENV Compute Observed Ripleys K and significance envelopes for Signal
%to points and points to signals.
%
%   [RK] = RKSigEnv(im,pts,r,mask,[0.01 0.05],'Sig2Pts') computes the
%   Ripley's K for a signal compared to points in a point process and
%   simulate CSR to compute significance envelopes for a=0.01 and a=0.05.
%
%   [RK] = RKSigEnv(im,pts,r,mask,[0.001],'Pts2Sig') computes the Ripley's
%   K for points in a point process to a signal in an image and simulate
%   CSR to compute signficance envelope for a=0.001. 
%
%   Use varargin to specify a second mask which defines where the point
%   process is simulated for the calculation of KCSR (if it is different
%   from the first input mask
%
%   SEE ALSO RKSIGNAL2PTS, RANDOMIZEPIXELS, RANDPPMASK. 

%% Check inputs
imRes = size(im);
maskRes = size(mask);
im = double(im);
if numel(imRes)==3
    im = rgb2gray(im);
    imRes = size(im);
elseif numel(imRes)~=2
    error('im must be a grayscale image')
end

if sum(imRes==maskRes)~=2
    error('Mask and image must have the same resolution')
end

pts = makeCoord(pts,2);

if numel(r)~=length(r)
    error('r must be a vector')
end

if sum(mask~=0 & mask~=1)~=0
    error('mask must be a binary image')
end

% if (sum(mask(:,1))/length(mask(:,1)))>0.1
%     warning('Mask was automatically inverted')
%     mask = ~mask;
% end

% Handle the case where no points are within the analysis area.
if isempty(pts)
    zermat = zeros(1,length(r));
    RK.Obs = zermat;
    RK.r = r;
    RK.CSR = zermat;
    RK.CSRSims = [];
    RK.SigLvls = [SigLvls'; -1*flipud(SigLvls')];
    RK.Type = CompType;
    RK.npts = 0;
    RK.pixTot = sum(im(:));
    RK.A = sum(mask(:));
    RK.Env = zeros(2*numel(SigLvls),length(r));
    return %terminate early
end


% Ensure all points are within the mask
pts = CropPts2Mask(pts,mask);

%% Compute Ripley's K (without edge correction) for the input point process
[K, npts, pixTot, A] = RKSignal2Pts(im,pts,r,mask);

%% Simulate CSR and recompute K

% Determine maximum number of simulations needed.
maxSigLvl = min(SigLvls);

nsims = 2/maxSigLvl-1;
% hw = waitbar(0,'Simulating');

switch CompType
    case 'Sig2Pts' % Assess how the signal compares to the points
        for i=1:nsims
            if nargin==7
                mask = varargin{1};
            end
            
            tic
            SimIm = RandomizePixels(im,mask);
            KSim(i,:) = RKSignal2Pts(SimIm,pts,r,mask);
%             TimePerSim(i) = toc; % min
%             TimeRem = mean(TimePerSim)*(nsims-i);
%             waitbar(i/nsims,hw,sprintf('Simulating CSR\nTime Remaining: %s',Toc2Time(TimeRem)))
        end
        
    case 'Pts2Sig' % Assess how the points compare to the signal. 
        for i=1:nsims
            if nargin==7
                mask = varargin{1};
            end
            
            tic
            SimPts = RandPPMask(npts,mask);
            KSim(i,:) = RKSignal2Pts(im,SimPts,r,mask);
            TimePerSim(i) = toc; % min
            TimeRem = mean(TimePerSim)*(nsims-i);
%             waitbar(i/nsims,hw,sprintf('Simulating CSR\nTime Remaining: %s',Toc2Time(TimeRem)))
        end
end

% delete(hw)
SigLvls = [SigLvls'; -1*flipud(SigLvls')];

RK.Obs = K;
RK.r = r;
RK.CSR = mean(KSim,1); % Average Ripley's K under CSR
RK.CSRSims = sort(KSim);
RK.SigLvls = SigLvls;
RK.Type = CompType;
RK.npts = npts;
RK.pixTot = pixTot;
RK.A = A;

% Extract signficance envelopes
for n = 1:length(SigLvls)
    if SigLvls(n)<0
        Inds = ceil(nsims*(-1*SigLvls(n))/2);
        a=1;
    elseif SigLvls(n)>0
        Inds = ceil(nsims*(SigLvls(n))/2);
        Inds = nsims-Inds+1;
        a=1;
    end
        
    RK.Env(n,:) = RK.CSRSims(Inds,:);
end

end
