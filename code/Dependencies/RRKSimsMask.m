function [KObs,KSims,FPosition,EObs,ESims,A,npts] = RRKSimsMask(pts,r,nFrames,fOverlap,SigLvl,Mask,varargin)
%RRKSimsMask Compute observed Ripley's K and Ripley's K under simulated CSR
%using a Rolling window approach. 
%   Detailed explanation goes here
p = inputParser;
addRequired(p,'pts',@isnumeric)
addRequired(p,'r',@isnumeric)
addRequired(p,'nFrames',@isnumeric)
addRequired(p,'fOverlap',@isnumeric)
addRequired(p,'SigLvl',@isnumeric)
addRequired(p,'Mask');

checkOrder = @(x) any(validatestring(x,{'ByFrame','ByImage'}));
addOptional(p,'Order','ByFrame',checkOrder)


parse(p,pts,r,nFrames,fOverlap,SigLvl,Mask,varargin{:})
Order = p.Results.Order;

%%
[MaskHeight,MaskWidth] = size(Mask);

win = [0 MaskWidth 0 MaskHeight];

% Compute Window Width
WinHeight = win(4)-win(3);
WinWidth = win(2)-win(1);
rLen = length(r);

% Compute Frame Dimensions
FWidth = WinWidth/(nFrames-nFrames*fOverlap+fOverlap);

FStarts = linspace(win(1),WinWidth-FWidth,nFrames);
FEnds = linspace(FWidth,win(2),nFrames);
FPosition = FEnds./WinWidth; % Frame position as fraction of window width.

% Simulation parameters
msims = (2/SigLvl)-1;

% Preallocate
EObs = zeros(nFrames,rLen);
ESims = zeros(nFrames,rLen,msims);
A = zeros(nFrames,1);
npts = zeros(nFrames,1);

%% Simulation
pbar = 0;
pbarmax = nFrames*msims;
tvec = nan(1,pbarmax);

hbar = waitbar(0,'Computing Observed K');

% Compute Observed
for n=1:nFrames
    CurFrame{n} = [FStarts(n) FEnds(n) win(3) win(4)];

    % Generate current mask
    CurMask{n} = Mask(1:WinHeight,floor(FStarts(n)+1):floor(FEnds(n)));
    A(n) = sum(CurMask{n}(:)); % Save Area

    % Compute current points and npts and KObs
    CurPts{n} = CropPts2Win(pts,CurFrame{n});
    npts(n) = length(CurPts{n}); % Save Number of Points
    CurPts{n}(:,1) = CurPts{n}(:,1)-FStarts(n); % Re-zero

    % Compute observed E
    [~,~,~,~,~,~,EObs(n,:)] = Kest(CurPts{n},CurFrame{n},'t',r,'EdgeCorrection','off','Mask',CurMask{n});
end

% Compute Simulated RRK
switch Order
    case 'ByFrame'
        for n=1:nFrames
            for m = 1:msims
                tic;
                RndPts = RandPPMask(npts(n),CurMask{n}); % Shuffle points

                % Compute simulated value
                [~,~,~,~,~,~,ESims(n,:,m)] = Kest(RndPts,CurFrame{n},'t',r,'EdgeCorrection','off','Mask',CurMask{n});

                %% Update progress bar
                [pbar,tvec] = UpdProgBar(pbar,pbarmax,tvec,hbar,n,nFrames,m,msims);
            end
        end
    case 'ByImage'
        for m = 1:msims
            RANDPts = RandPPMask(length(pts),Mask);
            for n=1:nFrames
                tic;
                RndPts = CropPts2Win(RANDPts,CurFrame{n});
                RndPts(:,1) = RndPts(:,1)-FStarts(n);
                % Compute simulated value
                [~,~,~,~,~,~,ESims(n,:,m)] = Kest(RndPts,CurFrame{n},'t',r,'EdgeCorrection','off','Mask',CurMask{n});
                %% Update progress bar
                [pbar,tvec] = UpdProgBar(pbar,pbarmax,tvec,hbar,n,nFrames,m,msims);
            end
        end
end


delete(hbar)

% Conver E's to K's using point process density.
LInv = A./(npts.*(npts-1)); % Inverse lambda (density)

KObs = bsxfun(@times,EObs,LInv);
KSims = bsxfun(@times,ESims,LInv);

end


function [pbar,tvec] = UpdProgBar(pbar,pbarmax,tvec,hbar,n,nFrames,m,msims)
%% Update progress bar
pbar = pbar+1;
% Time estimation
tvec(pbar) = toc;
meantime = mean(tvec,'omitnan');
ETR = round((pbarmax-pbar).*meantime/60); % Estimated Time Remaining
waitbar(pbar/pbarmax,hbar,sprintf('Simulating CSR Frame: %d/%d Sim:%d/%d \n Estimated Time Remaining: %d min',n,nFrames,m,msims,ETR))
end