function varargout = manualSegment(varargin)
% MANUALSEGMENT MATLAB code for manualSegment.fig
%      MANUALSEGMENT, by itself, creates a new MANUALSEGMENT or raises the existing
%      singleton*.
%
%      H = MANUALSEGMENT returns the handle to a new MANUALSEGMENT or the handle to
%      the existing singleton*.
%
%      MANUALSEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALSEGMENT.M with the given input arguments.
%
%      MANUALSEGMENT('Property','Value',...) creates a new MANUALSEGMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualSegment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualSegment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualSegment

% Last Modified by GUIDE v2.5 06-Jun-2018 10:59:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualSegment_OpeningFcn, ...
                   'gui_OutputFcn',  @manualSegment_OutputFcn, ...
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


% --- Executes just before manualSegment is made visible.
function manualSegment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualSegment (see VARARGIN)

% Choose default command line output for manualSegment
handles.output = hObject;

% Determine whether input was specified
if numel(varargin)==0
    % Load default image and display
    imRaw = imread('pears.png'); % Load Image
    [imH,imW,~] = size(imRaw);
    cents = [imW imH].*rand(50,2);
elseif numel(varargin)==2
    imRaw = varargin{1}; % Extract image
    cents = varargin{2}; % Extract centroids
    cents = reshape(cents,[length(cents) 2]); % Impose Nx2 column vector
    handles.loadButton.Enable = 'Off';
else
    error('Invalid number of inputs')
end

handles.imRaw = imRaw; % Store imRaw in handles structure.
handles.cents = cents; % Store Centroids in handles structure.
handles.centsSave = cents; % Backup centroids for "undo" function

% Update handles structure
guidata(hObject, handles);

% Update the axes
updateAxes(hObject,eventdata,handles)

% Create gdata to save;
gdata.Ax1Im = [];
gdata.ImRaw = [];
gdata.imType = 'Unspecified';
gdata.cents = cents;
setappdata(0,'gdata',gdata);

% UIWAIT makes manualSegment wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = manualSegment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(0,'gdata');


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% Ask the user to choose an image
[path, user_cancel]=imgetfile();

% Catch errors when the user cancels the image selection
if user_cancel
    msgbox(sprintf('Error'),'Error','Error');
    return
end

ImRaw = imread(path);

setappdata(0,'imraw',ImRaw);
setappdata(0,'Ax1Im',ImRaw);

% Save images in gdata
gdata = getappdata(0,'gdata');
gdata.ImRaw = ImRaw;
gdata.Ax1Im = ImRaw;
setappdata(0,'gdata',gdata);

displayImage(handles);


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,foldername] = uiputfile('*.png','Save Image As');

% Catch cancels
if filename == 0
    % user pressed cancel
    return % Return control to gui
end


% Write full file name
complete_name = fullfile(foldername,filename);

% Obtain image from app data.
Ax1Im = getappdata(0,'Ax1Im');

% Save the image.
imwrite(Ax1Im,complete_name);


% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)

% --- Executes on selection change in ImTypePopup.
function ImTypePopup_Callback(hObject, eventdata, handles)
% hObject    handle to ImTypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
imType = contents{get(hObject,'Value')};

% Save imtype
gdata = getappdata(0,'gdata');
gdata.imType = imType;


imraw = getappdata(0,'imraw');

switch imType
    case 'RGB'
        Ax1Im = imraw;
        setappdata(0,'Ax1Im',Ax1Im);
    case 'Grayscale'
        Ax1Im = rgb2gray(imraw);
        setappdata(0,'Ax1Im',Ax1Im);
    case 'Red'
        Ax1Im = imraw(:,:,1);
        setappdata(0,'Ax1Im',Ax1Im);
    case 'Green'
        Ax1Im = imraw(:,:,2);
        setappdata(0,'Ax1Im',Ax1Im);
    case 'Blue'
        Ax1Im = imraw(:,:,3);
        setappdata(0,'Ax1Im',Ax1Im);
end

displayImage(handles);

% Save Ax1Im
gdata.Ax1Im = Ax1Im;
setappdata(0,'gdata',gdata);


% --- Executes during object creation, after setting all properties.
function ImTypePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImTypePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% CustomFunctions
function displayImage(handles)
axes(handles.axes1)
imshow(getappdata(0,'Ax1Im'))


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 set(gcf,'toolbar','figure');

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[xpts,ypts] = getpts; % Prompt user for new points
newcents = [xpts ypts]; % Combine into 2 column vector

cents = handles.cents; % Extract centroids from handles structure.
handles.centsSave = cents; % Backup centroids for undo function

cents = [cents; newcents]; % Combine the old and new centroids

handles.cents = cents; % Update centroids structure.
guidata(hObject, handles);

gdata = getappdata(0,'gdata');
gdata.cents = handles.cents;
setappdata(0,'gdata',gdata);

% Update the axes
updateAxes(hObject,eventdata,handles)

% --- Executes on button press in removeButton.
function removeButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rectSel = getrect;
xmin = rectSel(1);
ymin = rectSel(2);
xmax = xmin+rectSel(3);
ymax = ymin+rectSel(4);

cents = handles.cents;
handles.centsSave = handles.cents;

% Remove selected centroids
cents((cents(:,1)>=xmin & cents(:,1)<=xmax) & (cents(:,2)>=ymin & cents(:,2)<=ymax),:)=[];

% Update handles structure
handles.cents = cents; % Store Centroids in handles structure.
guidata(hObject, handles);

gdata = getappdata(0,'gdata');
gdata.cents = handles.cents;
setappdata(0,'gdata',gdata);
% Update the axes
updateAxes(hObject,eventdata,handles)


function updateAxes(hObject,eventdata,handles)
axes(handles.axes1)
Centroids = handles.cents;

cla
hold on
imshow(handles.imRaw)
scatter(Centroids(:,1),Centroids(:,2),40,'filled','MarkerFaceAlpha',0.5,'MarkerFaceColor','b')
hold off


% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
centsSave = handles.cents;
handles.cents = handles.centsSave;
handles.centsSave = centsSave;
guidata(hObject, handles);

gdata = getappdata(0,'gdata');
gdata.cents = handles.cents;
setappdata(0,'gdata',gdata);

% Update the axes
updateAxes(hObject,eventdata,handles)


% --- Executes on button press in dispCentCheck.
function dispCentCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dispCentCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dispCentCheck
ax = handles.axes1;        % Specify the axis to send the image to.
axchild = ax.Children;
if get(hObject,'Value')
    set(ax.Children(1),'Visible','on')
else
    set(ax.Children(1),'Visible','off')
end

guidata(hObject,handles);
