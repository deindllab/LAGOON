function varargout = analyze_tracesCy3Cy5(varargin)
% analyze_tracesCy3Cy5 M-file for analyze_tracesCy3Cy5.fig
%      analyze_tracesCy3Cy5, by itself, creates a new analyze_tracesCy3Cy5 or raises the existing
%      singleton*.
%
%      H = analyze_tracesCy3Cy5 returns the handle to a new analyze_tracesCy3Cy5 or the handle to
%      the existing singleton*.
%
%      analyze_tracesCy3Cy5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in analyze_tracesCy3Cy5.M with the given input arguments.
%
%      analyze_tracesCy3Cy5('Property','Value',...) creates a new analyze_tracesCy3Cy5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyze_tracesCy3Cy5_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyze_tracesCy3Cy5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyze_tracesCy3Cy5

% Last Modified by GUIDE v2.5 19-Nov-2020 11:15:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analyze_tracesCy3Cy5_OpeningFcn, ...
                   'gui_OutputFcn',  @analyze_tracesCy3Cy5_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before analyze_tracesCy3Cy5 is made visible.
function analyze_tracesCy3Cy5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyze_tracesCy3Cy5 (see VARARGIN)

% Choose default command line output for analyze_tracesCy3Cy5
handles = guidata(hObject);
handles.output = hObject;
handles.vl1 = [];
handles.vl2 = [];
handles.clickpts1 = [];
handles.clickpts2 = [];
handles.FRETplot_sm = [];
handles.figure = [];
handles.GUI_fig_handle = hObject;  %get the GUI figure handle (for making the GUI the active figure)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analyze_tracesCy3Cy5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analyze_tracesCy3Cy5_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles = guidata(hObject);
varargout{1} = handles.output;
%varargout{1} = handles;

% --- Executes on button press in rightarrow.
function rightarrow_Callback(hObject, eventdata, handles)
% hObject    handle to rightarrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if(current_trace_num < handles.num_traces)
    set(handles.numberdisplay,'String',num2str(current_trace_num+1));
end

current_trace_num = str2num(get(handles.numberdisplay,'String'));
if (current_trace_num >= 1 && current_trace_num <= handles.num_traces);
    guidata(hObject, handles);
    refresh_Callback(hObject, eventdata, handles)
elseif (current_trace_num > handles.num_traces)
    
    set(handles.numberdisplay,'String',num2str(handles.num_traces));
    guidata(hObject, handles);

    refresh_Callback(hObject, eventdata, handles)
else 
    set(handles.numberdisplay,'String',num2str(1));
    guidata(hObject, handles);

    refresh_Callback(hObject, eventdata, handles)
end

%handles.output = handles;
%analyze_tracesCy3Cy5_OutputFcn(hObject,eventdata,handles)


% --- Executes on button press in leftarrow.
function leftarrow_Callback(hObject, eventdata, handles)
% hObject    handle to leftarrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if(current_trace_num > 1)
    set(handles.numberdisplay,'String',num2str(current_trace_num-1));
end

current_trace_num = str2num(get(handles.numberdisplay,'String'));
if (current_trace_num >= 1 && current_trace_num <= handles.num_traces);
    %FRET_plot(1,handles.time,handles.FRET_traces(:,current_trace_num),handles);
    guidata(hObject,handles);
    refresh_Callback(hObject, eventdata, handles)
elseif (current_trace_num < 1)
    set(handles.numberdisplay,'String',num2str(1));
    %FRET_plot(1,handles.time,handles.FRET_traces(:,1),handles);
    guidata(hObject,handles);
    refresh_Callback(hObject, eventdata, handles)
else 
    set(handles.numberdisplay,'String',num2str(handles.num_traces));
    %FRET_plot(1,handles.time,handles.FRET_traces(:,handles.num_traces),handles);
    guidata(hObject,handles);
    refresh_Callback(hObject, eventdata, handles)
end



% --- Executes during object creation, after setting all properties.
function numberdisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function numberdisplay_Callback(hObject, eventdata, handles)
% hObject    handle to numberdisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if (current_trace_num >= 1 && current_trace_num <= handles.num_traces);
    guidata(hObject, handles);
    refresh_Callback(hObject, eventdata, handles)
end



% --- Executes on button press in DeleteTrace.
function DeleteTrace_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
temp_U = [];
for i = 1:size(handles.U,2)
    if i ~= current_trace_num
        temp_U = [temp_U handles.U(1,i)];
    end
end
handles.U = temp_U;
handles.num_traces = size(handles.U,2);
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes on button press in normalize.
function normalize_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
figure(1);
[x,y] = ginput(2);
x1 = round(x(1)*handles.U(1,current_trace_num).fr_rt);
x2 = round(x(2)*handles.U(1,current_trace_num).fr_rt);
norm_Cy5_1 = mean(handles.U(1,current_trace_num).Cy5_1(x1:x2));
norm_Cy7_1 = mean(handles.U(1,current_trace_num).Cy7_1(x1:x2));
handles.U(1,current_trace_num).Cy5_1 = handles.U(1,current_trace_num).Cy5_1 - norm_Cy5_1;
handles.U(1,current_trace_num).Cy7_1 = handles.U(1,current_trace_num).Cy7_1 - norm_Cy7_1;
handles.U(1,current_trace_num).FRET_1 = handles.U(1,current_trace_num).Cy7_1./(handles.U(1,current_trace_num).Cy7_1 + handles.U(1,current_trace_num).Cy5_1);
%% Recalculate FRET


handles.U(1,current_trace_num).FRET_1 = (handles.U(1,current_trace_num).Cy7_1)./(handles.U(1,current_trace_num).Cy7_1 + handles.U(1,current_trace_num).Cy5_1);
guidata(hObject,handles);
threshold_FRET_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function zoom_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function zoom_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
handles.zoom_val = str2num(get(handles.zoom,'String'));
guidata(hObject, handles);
%%% Update Plot
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function flow_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function flow_Callback(hObject, eventdata, handles)
% handles.flow_frame = str2num(get(handles.flow,'String'));
handles = guidata(hObject);
if ~isempty(handles.vl1)
    delete(handles.vl1);
    handles.vl1 = [];
    delete(handles.vl2);
    handles.vl2 = [];
end
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function frame_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function frame_rate_Callback(hObject, eventdata, handles)
% hObject    handle to flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.fr_rt = str2num(get(handles.frame_rate,'String'));
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes on button press in click_pts.
function click_pts_Callback(hObject, eventdata, handles)
% hObject    handle to click_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));

if ~isempty(handles.U(1,current_trace_num).click_frames)
    set(handles.click_pts,'Enable','on');
    set(handles.click_pts,'Value',get(handles.click_pts,'Max'));
    set(handles.show_click_pts,'Enable','on');
else
    set(handles.click_pts,'Value',get(handles.click_pts,'Min'));
    set(handles.click_pts,'Enable','off');
    set(handles.show_click_pts,'Enable','off');
end
guidata(hObject, handles);


% --- Executes on button press in show_click_pts.
function show_click_pts_Callback(hObject, eventdata, handles)
% hObject    handle to show_click_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes on button press in Ttrans.
function Ttrans_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if isfield(handles.U,'ttrans')
	if ~isempty(handles.U(1,current_trace_num).ttrans)
        set(handles.Ttrans,'Enable','on');
        set(handles.Ttrans,'Value',get(handles.Ttrans,'Max'));
        set(handles.show_Ttrans,'Enable','on');
	else
        set(handles.Ttrans,'Value',get(handles.Ttrans,'Min'));
        set(handles.Ttrans,'Enable','off');
        set(handles.show_Ttrans,'Enable','off');
	end
end
guidata(hObject, handles);

% --- Executes on button press in show_Ttrans.
function show_Ttrans_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)



% --- Executes on button press in autocorr.
function autocorr_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if(get(handles.autocorr,'Value') == get(handles.autocorr,'Max'))
    set(handles.autocorr_win,'Enable','on');
    set(handles.autocorr_win,'String',num2str((handles.U(1,current_trace_num).num_fr-1)));
else
    set(handles.autocorr_win,'Enable','off');
end
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function autocorr_win_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function autocorr_win_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_value = str2num(get(handles.autocorr_win,'String'));
current_trace_num = str2num(get(handles.numberdisplay,'String'));
if current_value >= handles.U(1,current_trace_num).num_fr
    set(handles.autocorr_win,'String',num2str((handles.U(1,current_trace_num).num_fr-1)));
end
guidata(hObject, handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes on button press in trace_hist.
function trace_hist_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);
refresh_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      FILTERS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function avefilter_win_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function avefilter_win_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
%%% This value must be odd for the smooth moving average
if(mod(str2num(get(hObject,'String')),2) == 0)
    set(hObject,'String',num2str(str2num(get(hObject,'String'))-1));
end
guidata(hObject, handles);
avefilter_Callback(hObject, eventdata, handles);

% --- Executes on button press in avefilter.
function avefilter_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
%%% MOVING AVERAGE FILTER
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function median_win_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function median_win_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);
median_Callback(hObject, eventdata, handles);

% --- Executes on button press in median.
function median_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
%%% MEDIAN FILTER
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function linefilter_win_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function linefilter_win_Callback(hObject, eventdata, handles)
%%% This value must be even for line filtering
if(mod(str2num(get(hObject,'String')),2) == 1)
    set(hObject,'String',num2str(str2num(get(hObject,'String'))+1));
end
guidata(hObject, handles);
linefilter_Callback(hObject, eventdata, handles);

% --- Executes on button press in linefilter.
function linefilter_Callback(hObject, eventdata, handles)
%%% LINE FILTER
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function linefilter_thresh_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function linefilter_thresh_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)

%------------------------------------------- END FILTERS   ---------------------------------


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
current_trace_num = str2num(get(handles.numberdisplay,'String'));
set(handles.frame_rate,'String',num2str(handles.U(1,current_trace_num).fr_rt));
% set(handles.flow,'String',num2str(handles.U(1,current_trace_num).flow));
set(handles.threshold_val,'String',num2str(handles.U(1,current_trace_num).fretthresh));
guidata(hObject,handles);
click_pts_Callback(hObject, eventdata, handles)
Ttrans_Callback(hObject, eventdata, handles)
%%% Replot Figure 1 with all the current parameters
FRET_plot(hObject,handles);



% --- Executes on button press in OpenTrace.
function OpenTrace_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to OpenTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_trace_num = str2num(get(handles.numberdisplay,'String'));
current_trace = handles.U(1,current_trace_num).FRET_1(:,1);
openvar('current_trace');
guidata(hObject,handles);



% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inkey = lower(get(hObject,'CurrentCharacter'));

if isempty(inkey)
    return;
end
guidata(hObject,handles);
if (inkey=='[')
    rightarrow_Callback(hObject, eventdata, handles);
elseif (inkey=='p')
    leftarrow_Callback(hObject, eventdata, handles);
end

if (inkey=='d')
    DeleteTrace_Callback(hObject, eventdata, handles);
end
if (inkey=='n')
    normalize_Callback(hObject, eventdata, handles);
end
if (inkey==']')
    get_click_pts_Callback(hObject, eventdata, handles);
end

% --- Executes on button press in dye_intensity_plot.
function dye_intensity_plot_Callback(hObject, eventdata, handles)
refresh_Callback(hObject, eventdata, handles)

% --- Executes on button press in derivative.
function derivative_Callback(hObject, eventdata, handles)
refresh_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in distance.
function distance_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (~handles.dist_calculated)  %check to see if calculation to distance domain has already been performed
	dist_FRET = [];
    FRET_traces = handles.FRET_traces;
	for i=1:handles.num_traces
		for j=1:handles.num_fr
            if (FRET_traces(j,i) <= 0)
                FRET_traces(j,i) = 0.1; %gives a distance of 8.5nm at Ro=5.9
            elseif(FRET_traces(j,i) > 1)
                FRET_traces(j,i) = 1;
            end
            dist_FRET(j,i) = 5.9*(1/FRET_traces(j,i)-1)^(1/6);  %Ro = 5.9 for Cy5_1/Cy7_1
		end
	end
    handles.dist_FRET = dist_FRET;
    handles.dist_calculated = 1;
end

guidata(hObject,handles);
avefilter_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function threshold_val_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function threshold_val_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
guidata(hObject, handles);
threshold_FRET_Callback(hObject, eventdata, handles);

% --- Executes on button press in threshold_FRET.
function threshold_FRET_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
threshold = str2num(get(handles.threshold_val,'String'));
current_trace_num = str2num(get(handles.numberdisplay,'String'));

dyesum = handles.U(1,current_trace_num).Cy5_1 + handles.U(1,current_trace_num).Cy7_1;
[rows] = find(dyesum < threshold);
handles.U(1,current_trace_num).FRET_1 = handles.U(1,current_trace_num).Cy7_1./dyesum;
handles.U(1,current_trace_num).FRET_1(rows,1) = 0;
for z= 1:handles.num_traces
    
    handles.U(1,z).fretthresh = threshold;
end

guidata(hObject,handles);
refresh_Callback(hObject, eventdata, handles)




% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Call modaldlg with the argument 'Position'.
% user_response = modaldlg('Title','Confirm Close');
% switch user_response
% case {'No'}
%     % take no action
% case 'Yes'
%     % Prepare to close GUI application window
close all;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Find .mat or .traces workspace 
% CurrentDir = pwd;
[filename, path] = uigetfile('*.traces;*.mat','Choose FRET traces file:')
% cd(path);
k = strfind(filename,'.traces');
if k
    handles.U = trace_to_struct(strcat(path,filename));
else
   %%% Load the following vairables and store them in the handles structure 
    load([path filename],'U')
    handles.U = U
end

%%% Initialize some variables in the handles structure
set(handles.threshold_val,'String',num2str(handles.U(1,1).fretthresh));
handles.num_traces = size(handles.U,2);  
handles.zoom_val = 1;  
%handles.dist_calculated = 0;   %flag for determining if the conversion of the FRET traces to the distance domain has been calculated  
handles.clickfile_loaded = 0;

%%% Save the handles structure before passing it to FRET_plot
guidata(hObject, handles);

%%% Plot the 1st FRET trace and format the plot
refresh_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function save_struct_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to save_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

U = handles.U
  %  save(handles.filename,'click_frames','-append');
[file,path,filterindex] = uiputfile('*.mat','Molecule Struct')     %filterindex is set to zero if cancel button is clicked (or an error occurs), otherwise it's 1
if filterindex
    save_file_name = strcat(path,file)
    save(save_file_name,'U');
end
refresh_Callback(hObject, eventdata, handles)

% --- Executes on button press in get_click_pts.
function get_click_pts_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
% hObject    handle to get_click_pts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%button = questdlg('Do you want to get click points for the trace?');
%%we want to cycle through all traces and get the click points

% current_trace_num = str2num(get(handles.numberdisplay,'String'));
% if(current_trace_num > 1)
%     set(handles.numberdisplay,'String',num2str(current_trace_num-1));
% end
% 
% current_trace_num = str2num(get(handles.numberdisplay,'String'));
% if (current_trace_num >= 1 && current_trace_num <= handles.num_traces);
%     %FRET_plot(1,handles.time,handles.FRET_traces(:,current_trace_num),handles);
%     refresh_Callback(hObject, eventdata, handles)
% elseif (current_trace_num < 1)
%     set(handles.numberdisplay,'String',num2str(1));
%     %FRET_plot(1,handles.time,handles.FRET_traces(:,1),handles);
%     refresh_Callback(hObject, eventdata, handles)
% else 
%     set(handles.numberdisplay,'String',num2str(handles.num_traces));
%     %FRET_plot(1,handles.time,handles.FRET_traces(:,handles.num_traces),handles);
%     refresh_Callback(hObject, eventdata, handles)


    current_trace_num = str2num(get(handles.numberdisplay,'String'));
    click_points = [];
    fr_rt = str2num(get(handles.frame_rate,'String'));
    figure(handles.figure);
    [x,y] = ginput;      %get 2 pts
    num_click_pts = size(x,1);
    for i = 1:num_click_pts
        click_points = [click_points round(x(i)*fr_rt)];
    end
    handles.U(1,current_trace_num).click_frames = click_points;
    guidata(hObject,handles);
    click_pts_Callback(hObject, eventdata, handles)
    set(handles.show_click_pts,'Value',get(handles.show_click_pts,'Max'));    

%     guidata(hObject,handles);
    refresh_Callback(hObject, eventdata, handles)





function FRET_plot(hObject,handles)
handles = guidata(hObject);
% function called by analyze_tracesCy3Cy5 gui to plot FRET_traces. The idea is to
% have all the plotting info (format, labelin, etc.) in one function so it
% only has to be written out once and is easily adjustable

%fig_num is the figure number
%handles structure from the gui to get latest variables
    intensity_plot = 0;  %Flag for Cy3_1/accept dye plot
    distance = 0;        %Flag for ploting FRET as distance
    derivative = 0;      %Flag for plotting FRET derivative
    click_points = 0;
    ttrans = 0;
    autocorr = 0;
    ave_filter = 0;
    trace_hist = 0;
    median_filter = 0;
    
    line_filter = 0;


    current_trace_num = str2num(get(handles.numberdisplay,'String'));
    
    
    flow = str2num(get(handles.flow,'String'));
    fr_rt = str2num(get(handles.frame_rate,'String'));
    start = str2num(get(handles.start,'String'));
    med = str2num(get(handles.median,'String'));
    ave = str2num(get(handles.average,'String'));

    
    if start
        start = start/fr_rt;
    else
        start = flow/fr_rt;
    end
   
    flow = flow/fr_rt;
    X = handles.U(1,current_trace_num).time_1;
    if isfield(handles.U,'Cy5_1')
        if max(handles.U(1,current_trace_num).Cy5_1) == 0
            Cy5_1 = handles.U(1,current_trace_num).Cy5_2;
            Cy7_1 = handles.U(1,current_trace_num).Cy7_2;
        else
            Cy5_1 = handles.U(1,current_trace_num).Cy5_1;
            Cy7_1 = handles.U(1,current_trace_num).Cy7_1;
        end
    else
        Cy5_1 = handles.U(1,current_trace_num).Cy5_2;
        Cy7_1 = handles.U(1,current_trace_num).Cy7_2;
    end
        
    threshold = handles.U(1,current_trace_num).fretthresh;
    
    Y_1 = Cy7_1./(Cy5_1+Cy7_1);
    Y_1((Cy5_1+Cy7_1)<threshold) = 0;
    
    if ave
        Y_2 = smooth(Y_1,ave,'moving');
    else
        if med
            Y_2 = medfilt1(Y_1, med);
        end
    end

    if(get(handles.show_click_pts,'Value') == get(handles.show_click_pts,'Max'))
        click_points = 1;
    end
    
    if ishandle(handles.figure)
        figure(handles.figure);
        handles.Cy5plot.XData = X;
        handles.Cy5plot.YData = Cy5_1;
        handles.Cy7plot.XData = X;
        handles.Cy7plot.YData = Cy7_1;
        delete(handles.clickpts1);
        delete(handles.clickpts2);
        if click_points&&(~isempty(handles.U(1,current_trace_num).click_frames))          
            axes(handles.sp1);
            hold on
            handles.clickpts1 = vline(handles.U(1,current_trace_num).click_frames/fr_rt,'g');            
            hold off
            axes(handles.sp2);
            hold on
            handles.clickpts2 = vline(handles.U(1,current_trace_num).click_frames/fr_rt,'g');            
            hold off
        end
        
        if ave||med
            if ishandle(handles.FRETplot_sm)
                handles.FRETplot_sm.XData = X;
                handles.FRETplot_sm.YData = Y_2;
            else
                axes(handles.sp2);
                set(handles.FRETplot,'LineWidth',4);
                handles.FRETplot.Color(4) = 0.25;
                hold on
                handles.FRETplot_sm = plot(X,Y_2,'k','LineWidth',2);
                hold off
            end
%             handles.FRETplot.Color(4) = 0.25;
        else
            if ishandle(handles.FRETplot_sm)
                delete(handles.FRETplot_sm);
                handles.FRETplot.Color(4) = 1;
                set(handles.FRETplot,'LineWidth',2);
            end
        end
            
        handles.FRETplot.XData = X;
        handles.FRETplot.YData = Y_1;
        
        if flow&&(isempty(handles.vl1))
            axes(handles.sp1);
            tempT = start:flow:X(end);
            hold on
            handles.vl1 = vline(tempT,':k');   
            hold off
            axes(handles.sp2);
            hold on
            handles.vl2 = vline(tempT,':k');   
            hold off
        end
        
    %The figure doesn't yet exist
    else       
        handles.figure = figure();
        handles.sp1=subplot(2,1,1);
        ylabel('dye intensity');
        xlabel('time (sec)')
        
        handles.Cy5plot = plot(X,Cy5_1,'r','LineWidth',2);
        hold on
        handles.Cy7plot = plot(X,Cy7_1,'m','LineWidth',2);
        %hold on
       
%       Drawing vlines only if there is no vlines in the plot at the moment
        if flow
            tempT = start:flow:X(end);
            handles.vl1 = vline(tempT,':k');            
        end
        
        grid on
        if click_points
            delete(handles.clickpts1);
            handles.clickpts1 = vline(handles.U(1,current_trace_num).click_frames/fr_rt,'g');            
        end
        hold off;

        handles.sp2=subplot(2,1,2);
        ylabel('FRET')
        xlabel('time (sec)')
        ylim([-.4 1.4])
        set(gca,'ytick',-.2:.2:1.2)
        hold on
        if ave||med
            handles.FRETplot = plot(X,Y_1,'k','LineWidth',4);
            handles.FRETplot.Color(4) = 0.25;            
            handles.FRETplot_sm = plot(X,Y_2,'k','LineWidth',2);            
        else
            handles.FRETplot = plot(X,Y_1,'k','LineWidth',2);
        end

        if flow
            tempT = start:flow:X(end);
            handles.vl2 = vline(tempT,':k');            
        end        
        grid on
        if click_points
            delete(handles.clickpts2);
            handles.clickpts2 = vline(handles.U(1,current_trace_num).click_frames/fr_rt,'g');
        end
        linkaxes([handles.sp1,handles.sp2],'x');
        set(findall(handles.figure, '-property', 'fontsize'), 'fontsize', 14)
        hold off
    end
    set(handles.figure,'Name',strcat('Molecule #',num2str(current_trace_num),'/', num2str(handles.num_traces)));
%     set(gca,'FontSize', 14);

    figure(handles.GUI_fig_handle);
    guidata(hObject,handles);

return;





% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on get_click_pts and none of its controls.
function get_click_pts_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to get_click_pts (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start as text
%        str2double(get(hObject,'String')) returns contents of start as a double


% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function median_CreateFcn(hObject, eventdata, handles)
% hObject    handle to median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function average_Callback(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of average as text
%        str2double(get(hObject,'String')) returns contents of average as a double


% --- Executes during object creation, after setting all properties.
function average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
