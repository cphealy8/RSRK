function [data1,cdata,data3] = mySegment
%MYSEGMENT Automatically segment fluorescent images.
%    MYSEGMENT combines several individual image processing GUIs into a
%    single easy to use package. First MYSEGMENT prompts the user to load
%    an image and then select a channel to be analyzed (for multiplexed
%    images). MYSEGMENT then allows the user to select/segment objects in
%    the image by adjusting various parameters. The output of this step is
%    Centroids each marking an individual object in the image. Finally the
%    code allows the user to manually correct these centroids before
%    finally prompting the user to save the output of the function as a
%    .mat file. 
%
%    SEE ALSO IMAGELOAD, IMAGEMORPH, and MANUALSEGMENT
%% First load the image
data1 = imageLoad;
imRaw = data1.ImRaw; % Original unprocessed image
imGray = data1.Ax1Im; % Grayscale image (or grayscale image from chosen channel)

%% Process the image and select objects
cdata = imageMorph(imGray);
cdata.imRaw = imRaw;
centroids = cdata.RegionProps.Centroids;

%% Permit the user to manually adjust the centroids
data3 = manualSegment(imGray,centroids);
cdata.RegionProps.Centroids = data3.cents;

%% Prompt the user to save the data
msg = msgbox('Saving point process. Please wait.');
uisave('cdata')
delete(msg)
