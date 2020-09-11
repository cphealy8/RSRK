function [SigIm] = pts2signal(pts,win,imRes,sigKern,varargin)
%PTS2SIGNAL Convert a point process into a signal image.
%   Detailed explanation goes here

%% Parse inputs
p = inputParser;

addRequired(p,'pts',@isnumeric);
addRequired(p,'win',@isnumeric);
addRequired(p,'imRes',@isnumeric);
addRequired(p,'sigKern');
addOptional(p,'scalepts','true',@ischar);

parse(p,pts,win,imRes,sigKern,varargin{:});
scalepts = p.Results.scalepts;

%% Scale points to imRes
[pL,pW] = size(pts);
if pW>pL
    pts = pts';
end

winWidth = win(2)-win(1);
winHeight = win(4)-win(3);

imWidth = ceil(winWidth*imRes);
imHeight = ceil(winHeight*imRes);

pts = pts*imRes;


%% convert points to pixels
% pixID = pts2pix(pts,[imWidth imHeight]);
% ptCounts = countEntries(pixID);
% 
% im = zeros(imHeight,imWidth);
% im(unique(pixID)) = ptCounts;

imap = pts2Imap(pts,[imWidth imHeight]);

%% convolve with signal kernel 
SigIm = conv2(imap,sigKern,'same');
%normalize
SigIm = SigIm./max(SigIm(:));
end

