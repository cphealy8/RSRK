function [K,npts,pixTot,A] = RKSignal2Pts(im,pts,r,mask)
%RKSIGNAL2PTS Compute Bivariate Ripley's K comparing a signal to a point
%process.
%   Detailed explanation goes here

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


%% Adjust image and points
pts = CropPts2Mask(pts,mask);
im = im.*mask;

%% Compute a few useful parameters
nr = length(r);
npts = length(pts);
pixTot = sum(im(:));
A = sum(mask(:));

lambda = npts*pixTot/A; % Normalization factor ("Density")

%% Compute RK for Signal to Pts. 
scanmap = RKScanner(im,pts,r);
repIm = repmat(im,[1 1 nr]);

% Compute K
K = reshape(sum(sum(scanmap.*repIm,1),2),[1 nr]);

% Normalize K
K = (1/lambda)*K;
end

