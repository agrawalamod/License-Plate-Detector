function varargout = simple_gui(varargin)
clc;
% SIMPLE_GUI MATLAB code for simple_gui.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_gui

% Last Modified by GUIDE v2.5 29-Apr-2016 16:19:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_gui_OutputFcn, ...
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

function simple_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_gui (see VARARGIN)

% Choose default command line output for simple_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
initialize_gui(hObject, handles, false);

% --- Executes when selected object changed in unitgroup.
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes just before simple_gui is made visible.


% --- Outputs from this function are returned to the command line.
function varargout = simple_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.output;
% Get default command line output from handles structure




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[baseFileName,folder]=uigetfile('*.*','Specify an image file','on');

fullimageFileName=fullfile(folder,baseFileName);

axes1=imread(fullimageFileName);

axes(handles.axes1);
image(axes1)

[im, plate] = Demo(fullimageFileName);
axes2 = im;
axes(handles.axes2);
image(axes2)

[text, segment] = segmentation(plate)
axes3 = segment;
axes(handles.axes3);
image(axes3)

msgbox(text,'Character recognition');
