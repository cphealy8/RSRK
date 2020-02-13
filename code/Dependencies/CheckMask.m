function [mask] = CheckMask(mask,threshold)
%CHECKMASK Check to make sure a mask is not inverted. 
%   Detailed explanation goes here

% Make sure the mask is not inverted and correct if it is. 
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

