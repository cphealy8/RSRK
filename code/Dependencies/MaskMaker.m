[path, user_cancel]=imgetfile();
RAW = imread(path);

%% Marrow Mask
ImAdj = imadjust(RAW);
ImLC = localcontrast(ImAdj);
imMedian = medfilt2(ImLC,30.*[1 1]); % Remove noise

imAdj2 = imadjust(imMedian); % Re-contrast
imBW = imbinarize(imAdj2,0.3); % Convert to BW image.

% Binary Open
openim = imopen(imBW,strel('disk',10));

% Binary Close
closeim = imclose(openim,strel('disk',20));

% Invert image
mask = closeim;

imshowmask(RAW,logical(mask));
%% Save
[spath,fname]=fileparts(path);
fname = strcat(fname(1:end-1),'basemask.png');
imwrite(mask,fullfile(spath,fname));


% %% Outer Mask
% imThresh = RAW>=5;
% 
% % Binary Open
% openim = imopen(imThresh,strel('disk',10));
% 
% % Binary Close
% closeim = imclose(openim,strel('disk',200));
% imshow(closeim)
% 
% % Invert image
% mask = closeim;



