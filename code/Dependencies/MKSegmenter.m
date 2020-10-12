% Code for segmenting megakaryocytes from an image.

[ImFile,ImPath] = uigetfile('../../data/*png','Select Image to Segment');
[MaskFile,MaskPath] = uigetfile(fullfile(ImPath,'*bmp'),'Select Mask File');
RAW = imread(fullfile(ImPath,ImFile));
Mask = ~imread(fullfile(MaskPath,MaskFile));


%% Apply mask to image
imMasked = double(RAW).*double(Mask);
imMasked = uint8(imMasked);
% RAW = RAW(8000:12000,1:4000); % For testing
%% Marrow Mask
imContrast = localcontrast(imMasked);

%%
imThresh =imContrast;
imThresh(imThresh<20) = 0; % Remove low intensity pixels

imMedian = medfilt2(imThresh,10.*[1 1]); % Remove noise
imFlat = imflatfield(imMedian,20); % Correct background illumination

imAdj = imadjust(imFlat); % Re-contrast
imBW = imbinarize(imAdj,0.3); % Convert to BW image.

% Fill holes in ring shaped cells
imDil = imdilate(imBW,strel('disk',2)); 
imFill = imfill(imDil,'holes');
imEr = imerode(imFill,strel('disk',2));

% Refine binary selection (
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
pts = cprops.Centroid;

% Visualize for testing
% imshow(labeloverlay(imContrast,imFill));
imshow(imContrast)
hold on
plot(pts(:,1),pts(:,2),'.r','MarkerSize',5)

%% Save
ppname = strcat(ImFile(1:end-5),'MKPP.mat');
save(fullfile(ImPath,ppname),'pts');
% imwrite(mask,fullfile(ImPath,ppname));



