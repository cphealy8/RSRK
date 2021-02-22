function varargout = imageLoad(varargin)
% IMAGELOAD MATLAB code for imageLoad.fig
%      IMAGELOAD, by itself, creates a new IMAGELOAD or raises the existing
%      singleton*.
%
%      H = IMAGELOAD returns the handle to a new IMAGELOAD or the handle to
%      the existing singleton*.
%
%      IMAGELOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGELOAD.M with the given input arguments.
%
%      IMAGELOAD('Property','Value',...) creates a new IMAGELOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageLoad_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageLoad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%      Author: Connor Healy (connor.healy@utah.edu)
%      Affiliation: Dept. of Biomedical Engineering, University of Utah.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageLoad

% Last Modified by GUIDE v2.5 02-Jan-2018 14:51:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageLoad_OpeningFcn, ...
                   'gui_OutputFcn',  @imageLoad_OutputFcn, ...
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


% --- Executes just before imageLoad is made visible.
function imageLoad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageLoad (see VARARGIN)

% Choose default command line output for imageLoad
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Create gdata to save;
gdata.Ax1Im = [];
gdata.ImRaw = [];
gdata.imType = 'Unspecified';
setappdata(0,'gdata',gdata);

% UIWAIT makes imageLoad wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = imageLoad_OutputFcn(hObject, eventdata, handles) 
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
