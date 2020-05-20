function [MaxScale] = MaskAnalyze(mask,nFrames,fOverlap,type)
%MASKANALYZE determine maximum analyzable scale for RSRK based on Mask.
%   The max analyzable scale for each window is defined as the radius of
%   the circle with equivalent area to the largest region in the window.
%

[MaskWidth,MaskHeight] = size(mask);
[WindowWidth,WindowHeight] = WWidth(mask,nFrames,fOverlap);

iStart = floor(linspace(1,MaskWidth-WindowWidth+1,nFrames));
iStop = iStart+(WindowWidth-1);
xStart = iStart-1;
xStop = iStop;
dX = cumsum([0 diff(xStart)]);

% Crop windows and analyze.
for n = 1:nFrames
    mindim = floor(sqrt(MaskHeight*MaskWidth)/1000); % remove small pixel noise
    CurMask = mask(iStart(n):iStop(n),:);
    CurMask = bwareafilt(CurMask,[mindim inf]);
    rprops = regionprops(CurMask,'EquivDiameter');
    EqDiam = [rprops.EquivDiameter];
    switch type
        case 'max'
            mEqDiam = max(EqDiam);
        case 'median'
            mEqDiam = median(EqDiam);
        case 'min'
            mEqDiam = min(EqDiam);
        case 'mean'
            mEqDiam = mean(EqDiam);
    end
    
    if isempty(mEqDiam)
        mEqDiam=0;
    end
    MaxScale(n) = mEqDiam/2;
end

end

