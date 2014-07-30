function varargout = MusicMan(varargin)
% MUSICMAN MATLAB code for MusicMan.fig
%      MUSICMAN, by itself, creates a new MUSICMAN or raises the existing
%      singleton*.
%
%      H = MUSICMAN returns the handle to a new MUSICMAN or the handle to
%      the existing singleton*.
%
%      MUSICMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSICMAN.M with the given input arguments.
%
%      MUSICMAN('Property','Value',...) creates a new MUSICMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MusicMan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MusicMan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MusicMan

% Last Modified by GUIDE v2.5 28-May-2014 13:47:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MusicMan_OpeningFcn, ...
                   'gui_OutputFcn',  @MusicMan_OutputFcn, ...
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


% --- Executes just before MusicMan is made visible.
function MusicMan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MusicMan (see VARARGIN)

% Choose default command line output for MusicMan
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MusicMan wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MusicMan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in export_btn.
function export_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in instrument_list.
function instrument_list_Callback(hObject, eventdata, handles)
% hObject    handle to instrument_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns instrument_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from instrument_list


% --- Executes during object creation, after setting all properties.
function instrument_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to instrument_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in instrument_btn.
function instrument_btn_Callback(hObject, eventdata, handles)
% hObject    handle to instrument_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in transcript_btn.
function transcript_btn_Callback(hObject, eventdata, handles)
% hObject    handle to transcript_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
