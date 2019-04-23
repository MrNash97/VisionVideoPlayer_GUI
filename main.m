function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 15-Apr-2019 14:23:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)


% Choose default command line output for main
handles.output = hObject;

% Create video object
% Putting the object into manual trigger mode and then
% starting the object will make GETSNAPSHOT return faster
% since the connection to the camera will already have
% been established.
% 
% dataDir = './data';
% vidFile = fullfile(dataDir,'yudha-result.avi');
% handles.videoFileReader = vision.VideoFileReader(vidFile);
% handles.frame   = step(handles.videoFileReader);
% handles.fig=image(handles.frame);

video = vision.VideoFileReader();
handles.video = video;
handles.frameCount = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ video_file_name,video_file_path ] = uigetfile({'*.avi'},'Pick a video file');      %;*.png;*.yuv;*.bmp;*.tif'},'Pick a file');
if(video_file_path == 0)
    return;
end
input_video_file = [video_file_path,video_file_name];
fullpath = strcat(video_file_path,video_file_name);
set(handles.edit1,'String',fullpath);
video = vision.VideoFileReader(input_video_file);
frame = step(video);
%frameCount = frameCount + 1;
axes(handles.axes1);set(handles.StartButton,'String','Start');
imshow(frame);
drawnow;
axis(handles.axes1,'off');

%     for nChannel = 1:3
%         colorChannel = frame(:,:,nChannel);
%         %colorChannel = colorChannel.*mask; % for masked image
%         frame(:,:,nChannel) = colorChannel;
%     end

%    for nChannel = 1:3
%        colorChannel = frame(:,:,nChannel);
%        colorChannel(colorChannel==0) = NaN;
%        rawColorSignal(nChannel,handles.frameCount) =  mean(mean(colorChannel,'omitnan'),'omitnan');
%    end
%plot(handles.frameCount,rawColorSignal(1, :),'r',handles.frameCount,rawColorSignal(2, :),'g',handles.frameCount,rawColorSignal(3, :),'b','Parent', handles.axes2);
%drawnow;

% Display Frame Number
%Update handles
handles.video = video;
guidata(hObject,handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.StartButton,'String'),'Pause')
    set(handles.StartButton,'String','Start');
else
    set(handles.StartButton,'String','Pause');
end
video = handles.video;
%axis(handles.axes1);
if  isDone(video)
    reset(video)
    handles.frameCount = 0;
end
%handles.frameCount = handles.frameCount + 1;
 while ~isDone(video) && strcmp(get(handles.StartButton,'String'),'Pause')
     frame   = step(video);
     imshow(frame,'Parent',handles.axes1); %plot frame is specific axis
     drawnow;
%     for nChannel = 1:3
%        colorChannel = frame(:,:,nChannel);
        %colorChannel(colorChannel==0) = NaN;
%        rawColorSignal(nChannel,frameCount) =  mean(mean(colorChannel));
%     end
 end
%plot(frameCount,rawColorSignal(1, :),'r',frameCount,rawColorSignal(2, :),'g',frameCount,rawColorSignal(3, :),'b','Parent', handles.axes2);
%drawnow;
 set(handles.StartButton,'String','Start');

% --- Executes on button press in PauseButton.
function PauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to PauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2)
surf(membrane(3))

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
