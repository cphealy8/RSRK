[path, user_cancel]=imgetfile();
RAW = imread(path);

%% Marrow Mask
imThresh = RAW>=20;

% Binary Open
openim = imopen(imThresh,strel('disk',10));

% Binary Close
closeim = imclose(openim,strel('disk',20));

% Invert image
mask = ~closeim;

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



