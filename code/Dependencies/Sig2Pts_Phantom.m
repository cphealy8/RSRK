function [pts] = Sig2Pts_Phantom(SigIm,multiplier,TgtNum)
%SIG2PTS_PHANTOM generates a point process spatially arranged with respect
%to a Signal Image. 

%   [pts] = Sig2Pts_Phantom(SigIm,1,100) generates 100 points that are
%   positively associated with the input signal image and outputs their 
%   coordinates. 
%
%   [pts] = Sig2Pts_Phantom(SigIm,-1,100) generates 100 points that are
%   negatively associated with the input signal image and outputs their 
%   coordinates.
[sigW,sigH] =size(SigIm);

% Convert to probability matrix. 
pmat = double(SigIm);
pmat = pmat/max(pmat(:));
pmat = abs(multiplier)*pmat;

% Generate random mat;
rmat = rand(sigW,sigH);

% Pixels with rmat values less than the corresponding pmat value get a
% point.
if multiplier>0 
    pixmat = rmat<=pmat;
else
    pixmat = rmat>=pmat;
end


% Convert the pixels to coordinates
pts = pix2pts(pixmat);

%
numpts = length(pts);

diffnum = numpts-TgtNum;
if diffnum>0
    omitpts = randsample(numpts,diffnum);
    pts(omitpts,:) = [];
elseif diffnum<0 & ~isinf(TgtNum)
    warning('Target number of points not reached')
end

% % Figure
% imshow(SigIm);
% hold on 
% plot(pts(:,1),pts(:,2),'.r')
end


