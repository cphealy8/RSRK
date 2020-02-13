function varargout = imageMorph(varargin)
% IMAGEMORPH Interactive image thresholding
%      Opens a image thresholding GUI which allows the user to load an
%      image, converts that image to grayscale, then allows the user to
%      specify a range of pixel intensity that they wish to remain in the
%      image, pixels outside this range are set to zero.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 04-Jun-2018 16:03:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageMorph_OpeningFcn, ...
                   'gui_OutputFcn',  @imageMorph_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before imageMorph is made visible.
function imageMorph_OpeningFcn(hObject, eventdata, handles, varargin)
%% Specify GUI defaults
handles.output = hObject;

% Determine whether input was specified
if numel(varargin)==0
% Load default image and display
imRaw = imread('pears.png'); % Load Image
else 
imRaw = varargin{1};
handles.loadButton.Enable = 'Off';
end

% Convert image to grayscale if necessary
if isRGB(imRaw) == 1
imGray = rgb2gray(imRaw);    % Convert to Grayscale
else
imGray = imRaw;
end

handles.imGray = imGray;     % Update handle

resetAll(hObject,eventdata,handles)

% Update the axes
updateAxes(hObject,eventdata,handles)

% Update handles structure
guidata(hObject, handles);

% Create gdata to save
gdata.MinIntensity = 0;
gdata.MaxIntensity = 255;
gdata.OpenStrength = 0;
gdata.CloseStrength = 0;
gdata.imGray = imGray;
gdata.imRaw = imRaw;
gdata.Ax1Im = imGray;
gdata.IsBinary = 0;

setappdata(0,'gdata',gdata);

% UIWAIT makes imageLoad wait for user response (see UIRESUME)
uiwait(handles.figure1);


function varargout = imageMorph_OutputFcn(hObject, eventdata, handles) 
%% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(0,'gdata');


function minSlider_Callback(hObject, eventdata, handles)
%% Specify what happens when the low threshold slider is moved
% hObject    handle to minSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.minSlider.Value = hObject.Value;
handles.minEdit.String = num2str(round(handles.minSlider.Value));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save low threshold slider value
gdata = getappdata(0,'gdata');
gdata.MinIntensity = round(hObject.Value);
setappdata(0,'gdata',gdata);


% --- Executes during object creation, after setting all properties.
function minSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.maxSlider.Value = hObject.Value;
handles.maxEdit.String = num2str(round(handles.maxSlider.Value));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save high threshold slider value
gdata = getappdata(0,'gdata');
gdata.MaxIntensity = round(hObject.Value);
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function maxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function CloseSlider_Callback(hObject, eventdata, handles)
% hObject    handle to CloseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.CloseTest = handles.CloseSlider.Value;
handles.CloseSlider.Value = hObject.Value;
handles.CloseEdit.String = num2str(round(handles.CloseSlider.Value));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save high threshold slider value
gdata = getappdata(0,'gdata');
gdata.CloseStrength = round(hObject.Value);
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function CloseSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CloseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function OpenSlider_Callback(hObject, eventdata, handles)
% hObject    handle to OpenSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.OpenTest = handles.OpenSlider.Value;
handles.OpenSlider.Value = hObject.Value;
handles.OpenEdit.String = num2str(round(handles.OpenSlider.Value));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save high threshold slider value
gdata = getappdata(0,'gdata');
gdata.OpenStrength = round(hObject.Value);
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function OpenSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Ask the user to choose an image
[path, user_cancel]=imgetfile();

% Load in gdata
gdata = getappdata(0,'gdata');

% Catch errors when the user cancels the image selection
if user_cancel
    msgbox(sprintf('Error'),'Error','Error');
    return
end

% Read in the image
imRaw = imread(path);
gdata.imRaw = imRaw;

if isRGB(imRaw) == 1
imGray = rgb2gray(imRaw);    % Convert to Grayscale
else
imGray = imRaw;
end

handles.imGray = imGray;     % Update handle
gdata.imGray = imGray;

% Restore defaults
resetAll(hObject,eventdata,handles)

% Update the axes
updateAxes(hObject,eventdata,handles)

% Update handles structure
guidata(hObject, handles);

% Save gdata
setappdata(0,'gdata',gdata)


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,foldername] = uiputfile({'*.png','*.eps'},'Save Image As');
complete_name = fullfile(foldername,filename);
updateAxes(hObject,eventdata,handles)
imsave = getappdata(0,'imThresh');
imwrite(imsave,complete_name);


% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetAll(hObject,eventdata,handles)
updateAxes(hObject,eventdata,handles)

function minEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minEdit as text
%        str2double(get(hObject,'String')) returns contents of minEdit as a double
handles.minSlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save low threshold slider value
gdata = getappdata(0,'gdata');
gdata.MinIntensity = round(str2double(hObject.String));
setappdata(0,'gdata',gdata);


% --- Executes during object creation, after setting all properties.
function minEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in binCheck.
function binCheck_Callback(hObject, eventdata, handles)
% hObject    handle to binCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Update gdata storage structure
gdata = getappdata(0,'gdata');
gdata.IsBinary = hObject.Value;
setappdata(0,'gdata',gdata);


function maxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxEdit as text
%        str2double(get(hObject,'String')) returns contents of maxEdit as a double
handles.maxSlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save high threshold slider value
gdata = getappdata(0,'gdata');
gdata.MaxIntensity = round(str2double(hObject.String));
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function maxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function OpenEdit_Callback(hObject, eventdata, handles)
% hObject    handle to OpenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OpenEdit as text
%        str2double(get(hObject,'String')) returns contents of OpenEdit as a double
handles.OpenSlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save low threshold slider value
gdata = getappdata(0,'gdata');
gdata.OpenStrength = round(str2double(hObject.String));
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function OpenEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CloseEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CloseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CloseEdit as text
%        str2double(get(hObject,'String')) returns contents of CloseEdit as a double
handles.CloseSlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save low threshold slider value
gdata = getappdata(0,'gdata');
gdata.CloseStrength = round(str2double(hObject.String));
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function CloseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CloseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in OrderCheckbox.
function OrderCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OrderCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OrderCheckbox
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

if get(hObject,'Value')
    state = 'Close-Open';
else
    state = 'Open-Close';
end

% Save minA Slider value
gdata = getappdata(0,'gdata');
gdata.MinRegionArea = round(hObject.Value);
setappdata(0,'gdata',gdata);

function updateAxes(hObject,eventdata,handles)
%% Update the threshold lines
axes(handles.threshaxis)
cla
binEdges = 0:2:255;
hold on
histogram(handles.imGray,binEdges,'Normalization','pdf','FaceColor','b')
plotLin('v',handles.minSlider.Value,'-r','LineWidth',2);
plotLin('v',handles.maxSlider.Value,'-r','LineWidth',2);
hold off
xlim([0 255])

%% Update the thresholded image
axes(handles.imaxis);        % Specify the axis to send the image to.
cla
imThresh = handles.imGray;
imThresh(imThresh < handles.minSlider.Value) = 0;
imThresh(imThresh > handles.maxSlider.Value) = 0;

% Handle the binary case
if handles.binCheck.Value == 1
    imThresh(imThresh~=0) = 255;
end

imSelect = imbinarize(imThresh,0); % The binary selection

%% Apply binary operations
SEOpen = strel('disk',round(handles.OpenSlider.Value));
SEClose = strel('disk',round(handles.CloseSlider.Value));
if handles.OrderCheckbox.Value == 0
    imSelect = imopen(imSelect,SEOpen);
    imSelect = imclose(imSelect,SEClose);
elseif handles.OrderCheckbox.Value == 1
    imSelect = imclose(imSelect,SEClose);
    imSelect = imopen(imSelect,SEOpen);
end

%% Add grid
[imW,imH] = size(imThresh);

if handles.GridCheck.Value == 1
    apothem = str2double(handles.GridEdit.String);
    gridim = hexGrid(apothem,imW,imH);
    imSelect = logical(~gridim.*imSelect);
end

%% Compute Centroids
gdata = getappdata(0,'gdata'); % Open gdata to write to it if necessary

if handles.CentCheck.Value == 1 % Only compute if requested (It speeds things up).
    stats = regionprops(imSelect,'Centroid','Solidity','Area');
    Centroids = cat(1,stats.Centroid); % Centroids of regions
    regArea = cat(1,stats.Area); % Area of regions [=] pixels^2
    solidity = cat(1,stats.Solidity); % Solidity/density of regions
    imArea = numel(imSelect); % Area of image [=] pixels^2
    AreaRat = regArea/imArea; % Ratio of region area to image area.
    AreaRatFull = AreaRat; % Full uncatenated list
    
    % Refine centroids
    solidThresh = handles.soliditySlider.Value;
    minAThresh = handles.minASlider.Value;
    maxAThresh = handles.maxASlider.Value;

    % Concatenate the property vectors based on the specified thresholds
    Centroids(solidity<solidThresh,:) = [];
    AreaRat(solidity<solidThresh) = [];
    Centroids(regArea<minAThresh,:) = [];
    AreaRat(regArea<minAThresh) = [];
    Centroids(regArea>maxAThresh,:) = [];
    AreaRat(regArea>maxAThresh) = [];
%     Centroids(AreaRat<minAThresh,:) = [];
%     AreaRat(AreaRat<minAThresh) = [];
%     Centroids(AreaRat>maxAThresh,:) = [];
%     AreaRat(AreaRat>maxAThresh) = [];
    % Adjust slider maximums
    handles.maxASlider.Max = imArea;
    handles.minASlider.Max = imArea;
    
    % Save the data for export
    gdata.RegionProps.Centroids = Centroids; % Coordinates of the centroid of each region.
    gdata.RegionProps.RegionArea = regArea; % Area of each binary region.
    gdata.RegionProps.AreaRatio = AreaRat; % Ratio of pixels in region to full image.
    gdata.RegionProps.Solidity = solidity; % Solidity/Density of region. 
else
    Centroids = [];
end

% Update the handles count
handles.CentCountEdit.String = num2str(length(Centroids));


%%
setappdata(0,'imThresh',imThresh);
setappdata(0,'imSelect',imSelect);

%% Display image
handles.imThresh = imThresh;
handles.imSelect = imSelect;

imshow(handles.imGray);      % Display Image

imOver = 255*ones(imW,imH,3);
imOver(:,:,2:3) = 0;
imOver = uint8(imOver);

if handles.overlayCheck.Value == 1
    hold on
    himT = imshow(imOver);
    hold off
    alpha = double(handles.imSelect)*0.5;
    set(himT,'AlphaData',alpha)
end

if handles.DispCentCheck.Value ==1 && ~isempty(Centroids)
    hold on
      scatter(Centroids(:,1),Centroids(:,2),40,'filled','MarkerFaceAlpha',0.5,'MarkerFaceColor','b')
        
    hold off
end

guidata(hObject,handles)

setappdata(0,'imThresh',imThresh);

% Save important things

gdata.imThresh = imThresh;
gdata.imSelect = imSelect;


setappdata(0,'gdata',gdata);


function resetAll(hObject,eventdata,handles)
%% Reset all parameters to default values
handles.minSlider.Min = 0;
handles.minSlider.Max = 255;
handles.minSlider.Value = 0;

handles.maxSlider.Min = 0;
handles.maxSlider.Max = 255;
handles.maxSlider.Value = 255;

handles.minEdit.String = num2str(0);
handles.maxEdit.String = num2str(255);
handles.OpenEdit.String = num2str(0);
handles.CloseEdit.String = num2str(0);

handles.OpenSlider.Value = 0;
handles.CloseSlider.Value = 0;

handles.imThresh = handles.imGray;
handles.binCheck.Value = 0;

handles.minAEdit.String = num2str(0);
AreaSlideMax = 1000000  ;
handles.maxASlider.Value = AreaSlideMax;
handles.minASlider.Value = 0;
handles.maxAEdit.String = num2str(AreaSlideMax);
handles.maxASlider.Max = AreaSlideMax;
handles.minASlider.Max = AreaSlideMax;
handles.solidityEdit.String = num2str(0);

handles.overlayCheck.Value = 1;
handles.CentCheck.Value = 0;
handles.GridCheck.Value = 0;
handles.DispCentCheck.Value = 1;
handles.GridEdit.String = num2str(50);
handles.CentCountEdit.String = num2str(0);

guidata(hObject,handles)

% Update gdata.
gdata = getappdata(0,'gdata');

gdata.MinIntensity = 0;
gdata.MaxIntensity = 255;
gdata.imThresh = handles.imGray;
gdata.IsBinary = 0;
gdata.OpenStrength = 0;
gdata.CloseStrenght = 0;
gdata.imSelect = [];
gdata.MinRegionArea = 0;
gdata.MaxRegionArea = 0.1;
gdata.MinSolidity = 0;
gdata.SamplingResolution = 0;
gdata.RegionProps = [];

setappdata(0,'gdata',gdata);

% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)

% --- Executes on button press in overlayCheck.
function overlayCheck_Callback(hObject, eventdata, handles)
% hObject    handle to overlayCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of overlayCheck

ax = handles.imaxis;        % Specify the axis to send the image to.
axchild = ax.Children;
nax = length(axchild)-1;
if get(hObject,'Value')
    set(ax.Children(nax),'Visible','on')
else
    set(ax.Children(nax),'Visible','off')
end

guidata(hObject,handles);


% --- Executes on button press in CentCheck.
function CentCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CentCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CentCheck
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);


% --- Executes on slider movement.
function minASlider_Callback(hObject, eventdata, handles)
% hObject    handle to minASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.minASlider.Value = hObject.Value;
handles.minAEdit.String = num2str(handles.minASlider.Value);
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save minA Slider value
gdata = getappdata(0,'gdata');
gdata.MinRegionArea = hObject.Value;
setappdata(0,'gdata',gdata);

% Save high threshold slider value
% gdata = getappdata(0,'gdata');
% gdata.MaxIntensity = round(hObject.Value);
% setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function minASlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function minAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minAEdit as text
%        str2double(get(hObject,'String')) returns contents of minAEdit as a double
handles.minASlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save min Region Area Value
gdata = getappdata(0,'gdata');
gdata.MinRegionArea = str2double(hObject.String);
setappdata(0,'gdata',gdata);


% --- Executes during object creation, after setting all properties.
function minAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function maxASlider_Callback(hObject, eventdata, handles)
% hObject    handle to maxASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.maxASlider.Value = hObject.Value;
handles.maxAEdit.String = num2str(handles.maxASlider.Value);
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save maxA Slider value
gdata = getappdata(0,'gdata');
gdata.MaxRegionArea = hObject.Value;
setappdata(0,'gdata',gdata);

% Save high threshold slider value
% gdata = getappdata(0,'gdata');
% gdata.MaxIntensity = round(hObject.Value);
% setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function maxASlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function maxAEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxAEdit as text
%        str2double(get(hObject,'String')) returns contents of maxAEdit as a double
% Hints: get(hObject,'String') returns contents of maxEdit as text
%        str2double(get(hObject,'String')) returns contents of maxEdit as a double
handles.maxASlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save max region Area
gdata = getappdata(0,'gdata');
gdata.MaxRegionArea = str2double(hObject.String);
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function maxAEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxAEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function soliditySlider_Callback(hObject, eventdata, handles)
% hObject    handle to soliditySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.soliditySlider.Value = hObject.Value;
handles.solidityEdit.String = num2str(handles.soliditySlider.Value);
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save soldity Slider value
gdata = getappdata(0,'gdata');
gdata.MinSolidity = hObject.Value;
setappdata(0,'gdata',gdata);



% --- Executes during object creation, after setting all properties.
function soliditySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soliditySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function solidityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to solidityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of solidityEdit as text
%        str2double(get(hObject,'String')) returns contents of solidityEdit as a double
% Hints: get(hObject,'String') returns contents of maxEdit as text
%        str2double(get(hObject,'String')) returns contents of maxEdit as a double
handles.soliditySlider.Value = str2double(get(hObject,'String'));
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

% Save low threshold slider value
gdata = getappdata(0,'gdata');
gdata.MinSolidity = str2double(hObject.String);
setappdata(0,'gdata',gdata);



% --- Executes during object creation, after setting all properties.
function solidityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solidityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GridEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GridEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GridEdit as text
%        str2double(get(hObject,'String')) returns contents of GridEdit as a double
updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

if handles.GridCheck.Value == 0
    gridrez = 0;
else
    gridrez = str2double(get(hObject,'String'));
end

% Save Sampling Resolution (hexagon apothem in pixels)
gdata = getappdata(0,'gdata');
gdata.SamplingResolution = gridrez;
setappdata(0,'gdata',gdata);

% --- Executes during object creation, after setting all properties.
function GridEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GridEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GridCheck.
function GridCheck_Callback(hObject, eventdata, handles)
% hObject    handle to GridCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GridCheck

updateAxes(hObject,eventdata,handles)
guidata(hObject,handles);

if handles.GridCheck.Value == 0
    gridrez = 0;
else
    gridrez = str2double(handles.GridEdit.String);
end

% Save Sampling Resolution (hexagon apothem in pixels)
gdata = getappdata(0,'gdata');
gdata.SamplingResolution = gridrez;
setappdata(0,'gdata',gdata);


% --- Executes on button press in DispCentCheck.
function DispCentCheck_Callback(hObject, eventdata, handles)
% hObject    handle to DispCentCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispCentCheck
ax = handles.imaxis;        % Specify the axis to send the image to.
axchild = ax.Children;
if get(hObject,'Value')
    set(ax.Children(1),'Visible','on')
else
    set(ax.Children(1),'Visible','off')
end

guidata(hObject,handles);


function CentCountEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CentCountEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentCountEdit as text
%        str2double(get(hObject,'String')) returns contents of CentCountEdit as a double


% --- Executes during object creation, after setting all properties.
function CentCountEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentCountEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function imaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 set(gcf,'toolbar','figure');

% Hint: place code in OpeningFcn to populate imaxis
