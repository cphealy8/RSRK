[path, user_cancel]=imgetfile();
RAW = imread(path);

% RAW = RAW(8000:12000,1:4000);
%% Marrow Mask
imContrast = localcontrast(RAW);

%%
imThresh =imContrast;
imThresh(imThresh<20) = 0;

imMedian = medfilt2(imThresh,10.*[1 1]);
imFlat = imflatfield(imMedian,20);

imAdj = imadjust(imFlat);
imBW = imbinarize(imAdj,0.3);
imDil = imdilate(imBW,strel('disk',2));
imFill = imfill(imDil,'holes');
imEr = imerode(imFill,strel('disk',2));
imOpen = imopen(imEr,strel('disk',2));
imClose = imclose(imEr,strel('disk',5));
%% watershed
imInvert = imClose;


D = -bwdist(~imInvert);
mask = imextendedmin(D,2);
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);

imShed = imInvert;
imShed(Ld2==0) = 0;

% refine from morphological params
props = regionprops('table',imShed,'EquivDiameter');
meanDiam = mean(props.EquivDiameter);
sdDiam = std(props.EquivDiameter);
minDiam = meanDiam-sdDiam;
% minDiam = 0;
if minDiam<0 
    minDiam=0;
end

smallRem = bwpropfilt(imShed,'EquivDiameter',[minDiam 200]);



cprops = regionprops('table',smallRem,'Centroid');
centers = cprops.Centroid;


imshow(labeloverlay(imContrast,imFill));
imshow(imContrast)
hold on
plot(centers(:,1),centers(:,2),'.r','MarkerSize',5)

% Binary Open
% openim = imopen(imThresh,strel('disk',2));


% % Binary Close
% closeim = imclose(openim,strel('disk',20));
% 
% % Invert image
% mask = ~closeim;

% %% Save
% [spath,fname]=fileparts(path);
% fname = strcat(fname(1:end-1),'basemask.png');
% imwrite(mask,fullfile(spath,fname));


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



