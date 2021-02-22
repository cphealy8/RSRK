function [mask] = CheckMask(mask,threshold)
%CHECKMASK Check to make sure a mask is not inverted. 
%   This function checks the boundary of mask and  determines the
%   fraction of pixels on the boundary that are black (masked out). If the
%   percentage of pixels that are black exceeds a user defined threshold
%   then CheckMask returns true (the mask is not inverted), otherwise it's
%   returns false. 
%
%   Author: Connor Healy (connor.healy@utah.edu)
%   AFFILIATION: Dept. of Biomedical Engineering, University of Utah.

%% Make sure the mask is not inverted and correct if it is. 
if (sum(mask(:,1))/length(mask(:,1)))>threshold
    f1 = figure;
    imshow(mask);
    choice = questdlg('Mask appears to be inverted. Invert before continuing?',...
        'Invert Mask?','Yes','No','Cancel','Cancel');
    close(f1)
    switch choice
        case 'Yes'
            mask = ~mask;
        case 'No'
            % Do Nothing
        case 'Cancel'
            return
    end
end
end

