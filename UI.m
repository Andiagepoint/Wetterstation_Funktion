function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 17-Nov-2013 14:40:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure

guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Speichert die Popup Inhalte für Single Request Prognose Details
setappdata(handles.single_request_progscope_popup,'Wind',{'' 'Staerke' 'Richtung' 'Gesamt' });
setappdata(handles.single_request_progscope_popup,'Temperatur',{'' 'Max' 'Min' 'Mittlere_temp_prog' 'Gesamt'});
setappdata(handles.single_request_progscope_popup,'Solarleistung',{'' 'Dauer' 'Einstrahlung' 'Gesamt'});
setappdata(handles.single_request_progscope_popup,'Luftdruck',{'keine Details verfügbar'});
setappdata(handles.single_request_progscope_popup,'Signifikantes_Wetter',{'keine Details verfügbar'});
setappdata(handles.single_request_progscope_popup,'Niederschlag',{'' 'Menge' 'Wahrscheinlichkeit' 'Gesamt'});
setappdata(handles.single_request_progscope_popup,'Markantes_Wetter',{'' 'Bodennebel' 'Gefrierender_Nebel' 'Bodenfrost' 'Boeen' 'Niederschlag' 'Hitze' 'Kaelte' 'Gesamt'});

setappdata(handles.single_request_progday_popup,'erste_Auspraegung',{'' 'Heute' 'Erster_Folgetag' 'Gesamt'});
setappdata(handles.single_request_progday_popup,'zweite_Auspraegung',{'' 'Heute' 'Erster_Folgetag' 'Zweiter_Folgetag' 'Dritter_Folgetag' 'Gesamt'});

%Alle Panels zu Beginn unsichtbar machen
set(handles.com_set_panel,'Visible','off');
set(handles.dataexp_set_panel,'Visible','off');
set(handles.single_request_panel,'Visible','off');
set(handles.multi_request_panel,'Visible','off');
set(handles.com_protocol_panel,'Visible','off');

%Popupmenüeinträge für Prognosestundenangaben
setappdata(handles.multi_request_from_proghour_popup,'erste_Auspraegung',{'' 'AM0_00' 'AM01_00' 'AM02_00' 'AM03_00' 'AM04_00' 'AM05_00' 'AM06_00' ...
                                                    'AM07_00' 'AM08_00' 'AM09_00' 'AM10_00' 'AM11_00' 'AM12_00' 'PM01_00' 'PM02_00' 'PM03_00' 'PM04_00' 'PM05_00' 'PM06_00' 'PM07_00' ...
                                                    'PM08_00' 'PM09_00' 'PM10_00' 'PM11_00' 'Gesamt'});
setappdata(handles.multi_request_from_proghour_popup,'zweite_Auspraegung',{'' 'Morgen' 'Vormittag' 'Nachmittag' 'Abend' 'Gesamt'});
setappdata(handles.multi_request_to_proghour_popup,'erste_Auspraegung',{'' 'AM0_00' 'AM01_00' 'AM02_00' 'AM03_00' 'AM04_00' 'AM05_00' 'AM06_00' ...
                                                    'AM07_00' 'AM08_00' 'AM09_00' 'AM10_00' 'AM11_00' 'AM12_00' 'PM01_00' 'PM02_00' 'PM03_00' 'PM04_00' 'PM05_00' 'PM06_00' 'PM07_00' ...
                                                    'PM08_00' 'PM09_00' 'PM10_00' 'PM11_00' 'Gesamt'});
setappdata(handles.multi_request_to_proghour_popup,'zweite_Auspraegung',{'' 'Morgen' 'Vormittag' 'Nachmittag' 'Abend' 'Gesamt'});

%Popupmenüeinträge für Com-Settings
set(handles.comset_parity_popup,'String',{'' 'none' 'even' 'odd' 'mark' 'space'});
set(handles.comset_baudrate_popup,'String',{'' '9600' '19200'});

%Benennung der Tabellenspalten auf dem Panel Sammelanfrage
set(handles.multi_request_msg_table,'ColumnName',{'Forecast scope', 'Forecast detail', 'Forecast start date', 'Forecast end date', 'Modbus message', 'Request'});
set(handles.single_request_response_table,'ColumnName',{'Forecast scope', 'Forecast detail', 'Forecast date', 'Modbus message', 'Response Value'});

%Popup-Menü-Inhalt für Intervallschritte
set(handles.multi_request_updateint_popup,'String',{'','6h','12h','18h','24h'});

%Initialisiere Protocol Liste
header = sprintf('%s %s','Communication protocol: ',datestr(now));
set(handles.com_protocol_listbox,'String',header);

guidata(hObject, handles);
drawnow;

h = gcf;
set(h,'DockControls','on');

% Load data structure with reg addresses to workspace
[filename, pathname] = uigetfile('*.mat','Load register addresses to workspace','C:\Users\AndiPower\Documents\MATLAB\Wetterstation\weather_station_data.mat');
load(strcat(pathname,filename));
assignin('base','data',data);
assignin('base','CityList',CityList);
assignin('base','CityList_Sorted',CityList_Sorted);
% Initialize popup menu for city id selection
set(handles.comset_city_id_popup,'String',strcat('',CityList_Sorted));

% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_status_Callback(hObject, eventdata, handles)

set(handles.com_set_panel,'Visible','off');
set(handles.dataexp_set_panel,'Visible','off');
set(handles.single_request_panel,'Visible','off');
set(handles.multi_request_panel,'Visible','off');
set(handles.com_protocol_panel,'Visible','on');

% --------------------------------------------------------------------
function menu_data_request_Callback(hObject, eventdata, handles)
% hObject    handle to menu_data_request (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function submenu_single_data_request_Callback(hObject, eventdata, handles)

set(handles.com_set_panel,'Visible','off');
set(handles.dataexp_set_panel,'Visible','off');
set(handles.single_request_panel,'Visible','on');
set(handles.multi_request_panel,'Visible','off');
set(handles.com_protocol_panel,'Visible','off');

% --------------------------------------------------------------------
function submenu_multi_data_request_Callback(hObject, eventdata, handles)

set(handles.com_set_panel,'Visible','off');
set(handles.dataexp_set_panel,'Visible','off');
set(handles.single_request_panel,'Visible','off');
set(handles.multi_request_panel,'Visible','on');
set(handles.com_protocol_panel,'Visible','off');

% --------------------------------------------------------------------
function menu_protocol_config_Callback(hObject, eventdata, handles)

set(handles.com_set_panel,'Visible','on');
set(handles.dataexp_set_panel,'Visible','off');
set(handles.single_request_panel,'Visible','off');
set(handles.multi_request_panel,'Visible','off');
set(handles.com_protocol_panel,'Visible','off');

% --------------------------------------------------------------------
function menu_data_export_Callback(hObject, eventdata, handles)

set(handles.com_set_panel,'Visible','off');
set(handles.dataexp_set_panel,'Visible','on');
set(handles.single_request_panel,'Visible','off');
set(handles.multi_request_panel,'Visible','off');
set(handles.com_protocol_panel,'Visible','off');

% --------------------------------------------------------------------
function menu_protocol_config_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to menu_protocol_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_data_export_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to menu_data_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in dataexp_select_data_storage_folder_button.
function dataexp_select_data_storage_folder_button_Callback(hObject, eventdata, handles)

single_data_pathname = uigetdir;
set(handles.dataexp_show_data_storage_path_edit,'String',single_data_pathname);
single_data_pathname = get(handles.dataexp_show_data_storage_path_edit,'string');

% --------------------------------------------------------------------
function auto_einzel_abruf_Callback(hObject, eventdata, handles)
% hObject    handle to auto_einzel_abruf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function auto_sammel_abruf_Callback(hObject, eventdata, handles)
% hObject    handle to auto_sammel_abruf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in multi_request_progscope_popup.
function multi_request_progscope_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_progscope_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_progscope_popup
set(handles.multi_request_from_progday_popup,'Value',1);
set(handles.multi_request_from_proghour_popup,'Value',1);
set(handles.multi_request_to_progday_popup,'Value',1);
set(handles.multi_request_to_proghour_popup,'Value',1);
set(handles.multi_request_progdetail_popup,'Value',1);

val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_prog_scope = string_list{val};
setappdata(handles.multi_request_progscope_popup,'sel_progscope',selected_string_prog_scope);
erste_A = getappdata(handles.single_request_progday_popup,'erste_Auspraegung');
zweite_A = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
switch selected_string_prog_scope
    case 'Luftdruck'
        Ld = getappdata(handles.single_request_progscope_popup,'Luftdruck');
        set(handles.multi_request_progdetail_popup,'String',Ld);
        set(handles.multi_request_from_progday_popup,'String',erste_A);
        set(handles.multi_request_to_progday_popup,'String',erste_A);
    case 'Markantes_Wetter'
        mW = getappdata(handles.single_request_progscope_popup,'Markantes_Wetter');
        set(handles.multi_request_progdetail_popup,'String',mW);
        set(handles.multi_request_from_progday_popup,'String',zweite_A);
        set(handles.multi_request_to_progday_popup,'String',zweite_A);
    case 'Niederschlag'
        niederschlag = getappdata(handles.single_request_progscope_popup,'Niederschlag');
        set(handles.multi_request_progdetail_popup,'String',niederschlag);
        set(handles.multi_request_from_progday_popup,'String',zweite_A);
        set(handles.multi_request_to_progday_popup,'String',zweite_A);
    case 'Signifikantes_Wetter'
        sW = getappdata(handles.single_request_progscope_popup,'Signifikantes_Wetter');
        set(handles.multi_request_progdetail_popup,'String',sW);
        set(handles.multi_request_from_progday_popup,'String',zweite_A);
        set(handles.multi_request_to_progday_popup,'String',zweite_A);
    case 'Solarleistung'
        solarP = getappdata(handles.single_request_progscope_popup,'Solarleistung');
        set(handles.multi_request_progdetail_popup,'String',solarP);
        set(handles.multi_request_from_progday_popup,'String',erste_A);
        set(handles.multi_request_to_progday_popup,'String',erste_A);
    case 'Temperatur'
        tmp = getappdata(handles.single_request_progscope_popup,'Temperatur');
        set(handles.multi_request_progdetail_popup,'String',tmp);
        set(handles.multi_request_from_progday_popup,'String',zweite_A);
        set(handles.multi_request_to_progday_popup,'String',zweite_A);
    case 'Wind'
        wind = getappdata(handles.single_request_progscope_popup,'Wind');
        set(handles.multi_request_progdetail_popup,'String',wind);
        set(handles.multi_request_from_progday_popup,'String',zweite_A);
        set(handles.multi_request_to_progday_popup,'String',zweite_A);
    otherwise
end
guidata(hObject, handles);
drawnow;


% --- Executes during object creation, after setting all properties.
function multi_request_progscope_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_progscope_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_progdetail_popup.
function multi_request_progdetail_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_progdetail_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_progdetail_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_progdetail = string_list{val};
setappdata(handles.multi_request_progdetail_popup,'sel_progdetail',selected_string_progdetail);
eAf = getappdata(handles.multi_request_from_proghour_popup,'erste_Auspraegung'); 
eAt = getappdata(handles.multi_request_to_proghour_popup,'erste_Auspraegung');
zAf = getappdata(handles.multi_request_from_proghour_popup,'zweite_Auspraegung');
zAt = getappdata(handles.multi_request_to_proghour_popup,'zweite_Auspraegung');
switch selected_string_progdetail
    case 'Mittlere_temp_prog'
        set(handles.multi_request_from_proghour_popup,'String',eAf);
        set(handles.multi_request_to_proghour_popup,'String',eAt);
    otherwise
        set(handles.multi_request_from_proghour_popup,'String',zAf);
        set(handles.multi_request_to_proghour_popup,'String',zAt);
end
        
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_progdetail_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_progdetail_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_from_progday_popup.
function multi_request_from_progday_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_from_progday_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_from_progday_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_from_progday = string_list{val};
setappdata(handles.multi_request_from_progday_popup,'sel_from_progday',selected_string_from_progday);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_from_progday_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_from_progday_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_from_proghour_popup.
function multi_request_from_proghour_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_from_proghour_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_from_proghour_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_from_proghour = string_list{val};
setappdata(handles.multi_request_from_proghour_popup,'sel_from_proghour',selected_string_from_proghour);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_from_proghour_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_from_proghour_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_to_proghour_popup.
function multi_request_to_proghour_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_to_proghour_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_to_proghour_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_to_proghour = string_list{val};
setappdata(handles.multi_request_to_proghour_popup,'sel_to_proghour',selected_string_to_proghour);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_to_proghour_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_to_proghour_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_to_progday_popup.
function multi_request_to_progday_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_to_progday_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_to_progday_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_to_progday = string_list{val};
setappdata(handles.multi_request_to_progday_popup,'sel_to_progday',selected_string_to_progday);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_to_progday_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_to_progday_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function multi_request_msg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_msg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multi_request_msg_edit as text
%        str2double(get(hObject,'String')) returns contents of multi_request_msg_edit as a double


% --- Executes during object creation, after setting all properties.
function multi_request_msg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_msg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in multi_request_updateint_popup.
function multi_request_updateint_popup_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_updateint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns multi_request_updateint_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multi_request_updateint_popup
% set(handles.multi_request_updateint_popup,'Value',1);
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_updateint = string_list{val};
selected_string_updateint_value = str2double(selected_string_updateint(1:length(selected_string_updateint)-1));
setappdata(handles.multi_request_updateint_popup,'sel_updateint_value',selected_string_updateint_value);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function multi_request_updateint_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_updateint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in multi_request_update_checkbox.
function multi_request_update_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_update_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multi_request_update_checkbox
if (get(hObject,'Value') == get(hObject,'Max'))
   setappdata(handles.multi_request_update_checkbox,'checkbox_set',1);
else
   setappdata(handles.multi_request_update_checkbox,'checkbox_set',0);
end
guidata(hObject,handles);

% --- Executes on button press in multi_request_msg_add_button.
function multi_request_msg_add_button_Callback(hObject, eventdata, handles)

table_data = get(handles.multi_request_msg_table, 'Data');
add_table_data = getappdata(handles.multi_request_gen_msg_button,'table_data');
if isempty(table_data) == 1
    set(handles.multi_request_msg_table,'Data',add_table_data);
else
    if isempty(table_data{1}) == 1 
        set(handles.multi_request_msg_table,'Data',add_table_data);
    else
        table_data = [table_data; add_table_data];
        set(handles.multi_request_msg_table,'Data',table_data);
    end
end
set(handles.multi_request_msg_table,'ColumnWidth',{100 100 150 150 110 80});
drawnow;

% --- Executes on button press in multi_request_msg_remove_button.
function multi_request_msg_remove_button_Callback(hObject, eventdata, handles)

selected_row = getappdata(handles.multi_request_msg_table,'SelRow');
table_data = get(handles.multi_request_msg_table, 'Data');
table_data(selected_row,:)=[];
set(handles.multi_request_msg_table,'Data',table_data);
drawnow;


% --- Executes on button press in multi_request_msg_removeall_button.
function multi_request_msg_removeall_button_Callback(hObject, eventdata, handles)

table_data = get(handles.multi_request_msg_table, 'Data');
table_data(:,:)=[];
set(handles.multi_request_msg_table,'Data',table_data);
drawnow;


% --- Executes on button press in multi_request_msg_savelist_button.
function multi_request_msg_savelist_button_Callback(hObject, eventdata, handles)

[filename,path] = uiputfile('*.mat');
table_data = get(handles.multi_request_msg_table,'Data');
save(strcat(path,filename),'table_data');
% export(dataset,'file',strcat(path,filename));

% --- Executes on button press in multi_request_msg_loadlist_button.
function multi_request_msg_loadlist_button_Callback(hObject, eventdata, handles)

[filename,path]  = uigetfile('*.mat');
load(strcat(path,filename));
set(handles.multi_request_msg_table,'Data',table_data);

% --- Executes on button press in multi_request_msg_sendbutton.
function multi_request_msg_sendbutton_Callback(hObject, eventdata, handles)

serial_interface_check();
data_struct_check();

% If update checkbox is activated update_checkbox will be 1.
update_checkbox = getappdata(handles.multi_request_update_checkbox,'checkbox_set');

% Decision between a single update call or an automated update cycle
% defined by the start and end date.
if update_checkbox == 1
    update_interval = getappdata(handles.multi_request_updateint_popup,'sel_updateint_value');
    update_start_date = get(handles.multi_request_start_date,'String');
    update_end_date = get(handles.multi_request_end_date,'String');

% If start date is today you first have to calculate the remaining hours
% till the end of that day, then you have to calculte the difference
% between the start and the end date to receive the number of days.
% Multiply with 24 to get the hours for those days. The number of update
% cycles is calculated then by dividing the sum of available hours round
% down the result and add 1 for the immediate request at time zero.
    if strcmp(update_start_date,date) == 1
        end_of_day = datevec(date)+[0 0 0 24 0 0];
        start_of_day = datevec(now);
        diff_today = etime(end_of_day,start_of_day)/3600;
        diff_days = days365(update_start_date,update_end_date)*24;
        update_cycle_number = floor((diff_today+diff_days)/update_interval)+1;
    else
        diff_days = days365(update_start_date,update_end_date)*24;
        update_cycle_number = floor(diff_days/update_interval);
    end

% The waiting period for the timer: interval for an update times 3600 sec
    update_interval_hours = update_interval*3600;

    % Create cell array for data aquisition
    weather_data = cell(1,4);
    assignin('base','weather_data',weather_data);
    
    % Here all requests are listed in a table, size of that table defines
    % the number of loops
    table_data = get(handles.multi_request_msg_table,'Data');
    size_table_data = size(table_data,1);
    
    % A timer is defined here to control the automatic update cycles.
    % Requests start with a 3 sec delay. The function to be executed after
    % the waiting period is send_loop, which triggers the communication
    % between Matlab and the weather station. The stop function deletes the
    % timer object after all tasks have been executed. 
    t = timer;
    t.StartDelay = 3;
    t.TimerFcn = {@send_loop, size_table_data, table_data, hObject, handles};
    t.StopFcn = @stop_timer;
    t.Period = update_interval_hours;
    t.TasksToExecute = update_cycle_number;
    t.ExecutionMode = 'fixedSpacing';
    start(t);
    
else
    
    table_data = get(handles.multi_request_msg_table,'Data');
    t = size(table_data,1);
    
    send_loop('','', t, table_data, hObject, handles, '');
    
end

function dataexp_show_data_storage_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dataexp_show_data_storage_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataexp_show_data_storage_path_edit as text
%        str2double(get(hObject,'String')) returns contents of dataexp_show_data_storage_path_edit as a double


% --- Executes during object creation, after setting all properties.
function dataexp_show_data_storage_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataexp_show_data_storage_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dataexp_select_protocol_storage_folder_button.
function dataexp_select_protocol_storage_folder_button_Callback(hObject, eventdata, handles)

protocol_pathname = uigetdir;
set(handles.dataexp_show_protocol_storage_path_edit,'String',protocol_pathname);
protocol_pathname = get(handles.dataexp_show_protocol_storage_path_edit,'String');


function dataexp_show_protocol_storage_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to text_protocol_storage_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_protocol_storage_path as text
%        str2double(get(hObject,'String')) returns contents of text_protocol_storage_path as a double


% --- Executes on button press in dataexp_select_cumdata_storage_folder_button.
function dataexp_select_cumdata_storage_folder_button_Callback(hObject, eventdata, handles)

multi_data_pathname = uigetdir;
set(handles.dataexp_show_cumdata_storage_path_edit,'String',multi_data_pathname);
multi_data_pathname = get(handles.dataexp_show_cumdata_storage_path_edit,'String');


function dataexp_show_cumdata_storage_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dataexp_show_cumdata_storage_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataexp_show_cumdata_storage_path_edit as text
%        str2double(get(hObject,'String')) returns contents of dataexp_show_cumdata_storage_path_edit as a double


% --- Executes during object creation, after setting all properties.
function dataexp_show_cumdata_storage_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataexp_show_cumdata_storage_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dataexp_show_protocol_storage_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataexp_show_protocol_storage_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in dataexp_save_storage_path_settings_button.
function dataexp_save_storage_path_settings_button_Callback(hObject, eventdata, handles)
% hObject    handle to dataexp_save_storage_path_settings_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in multi_request_gen_msg_button.
function multi_request_gen_msg_button_Callback(hObject, eventdata, handles)

data_struct_check();

% Popup Auswahl ermitteln
prog_scope = getappdata(handles.multi_request_progscope_popup,'sel_progscope');
if strcmp(prog_scope,'Luftdruck') == 1 || strcmp(prog_scope,'Signifikantes_Wetter') == 1
    prog_detail = [];
else
    prog_detail = getappdata(handles.multi_request_progdetail_popup,'sel_progdetail');
end
prog_day_from = getappdata(handles.multi_request_from_progday_popup,'sel_from_progday');
prog_hour_from = getappdata(handles.multi_request_from_proghour_popup,'sel_from_proghour');
prog_day_to = getappdata(handles.multi_request_to_progday_popup,'sel_to_progday');
prog_hour_to = getappdata(handles.multi_request_to_proghour_popup,'sel_to_proghour');

% Argumente bündeln
popup_scope_detail = {prog_scope, prog_detail};
popup_from = {prog_day_from, prog_hour_from};
popup_to = {prog_day_to, prog_hour_to};


% Registeraddressen ermitteln
[start_reg_address, field_name] = get_reg_address(popup_scope_detail, popup_from);
end_reg_address = get_reg_address(popup_scope_detail, popup_to);

device_address = dec2hex(str2num(get(handles.comset_device_id_edit,'String')),2);
setappdata(handles.comset_device_id_edit,'dev_address',device_address);

func_code = dec2hex(3,2);

% Überprüfung ob Intervall-Werte richtig ausgewählt wurden
[quantity_reg_addresses] = input_check(start_reg_address, end_reg_address, func_code, device_address);

% Modbus Nachricht zusammensetzen
modbus_msg = strcat(device_address,func_code,start_reg_address,quantity_reg_addresses);
set(handles.multi_request_msg_edit,'String',modbus_msg);

% CRC Summe berechnen und komplette Nachricht ausgeben
[modbus_msg_crc] = crc_calc(modbus_msg);
setappdata(handles.multi_request_msg_edit,'modbus_msg_crc',modbus_msg_crc);
table_data = {popup_scope_detail{1}, popup_scope_detail{2}, strcat(popup_from{1},'-',popup_from{2}), strcat(popup_to{1},'-',popup_to{2}), modbus_msg_crc, true}; 
setappdata(handles.multi_request_gen_msg_button,'table_data',table_data);
drawnow;

% --- Executes when selected cell(s) is changed in multi_request_msg_table.
function multi_request_msg_table_CellSelectionCallback(hObject, eventdata, handles)

selected_cells = eventdata.Indices;
setappdata(handles.multi_request_msg_table,'SelRow',selected_cells(1));


function comset_device_id_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_device_id_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_device_id_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_device_id_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_device_id_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_device_id_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in comset_baudrate_popup.
function comset_baudrate_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns comset_baudrate_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comset_baudrate_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_baudrate = string_list{val};
setappdata(handles.comset_baudrate_popup,'sel_baudrate',selected_baudrate);

% --- Executes during object creation, after setting all properties.
function comset_baudrate_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_baudrate_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in comset_parity_popup.
function comset_parity_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns comset_parity_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comset_parity_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_parity = string_list{val};
setappdata(handles.comset_parity_popup,'sel_parity',selected_parity);

% --- Executes during object creation, after setting all properties.
function comset_parity_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_parity_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comset_com_adress_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_com_adress_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_com_adress_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_com_adress_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_com_adress_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_com_adress_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comset_data_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_data_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_data_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_data_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comset_station_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_station_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_station_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_station_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_station_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_station_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comset_stop_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_stop_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_stop_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_stop_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in comset_close_serial_port.
function comset_close_serial_port_Callback(hObject, eventdata, handles)

% Check whether serial interface is available in workspace
serial_interface_check();

serial_interface = evalin('base','serial_interface');

% Close serial interface
close_serial_port( serial_interface );

% Show disconnected status in gui through color change to red
set(handles.status_con_status,'BackgroundColor',[1 0 0]);
set(handles.status_con_status,'String','Disconnected');
set(handles.status_con_quality_text,'Backgroundcolor',[1 0 0]);

% Clears the bar plot
cla(handles.status_con_quality_bar);
set(handles.status_con_quality_bar,'XLim',[-0.5 10]);
set(handles.status_con_quality_bar,'YLim',[0 10]);
set(handles.status_con_quality_bar,'XTickLabelMode','Manual');
set(handles.status_con_quality_bar,'XTick',[]);
set(handles.status_con_quality_bar,'YTickLabelMode','Manual');
set(handles.status_con_quality_bar,'YTick',[]);


% --- Executes on button press in comset_open_serial_port.
function comset_open_serial_port_Callback(hObject, eventdata, handles)

% Check if data structure is available
data_struct_check();

h = waitbar(0,'Please wait while establishing serial interface...');
% Read values from popup menu or edit fields
waitbar(1/4,h)

baudrate = str2double(getappdata(handles.comset_baudrate_popup,'sel_baudrate'));
parity = getappdata(handles.comset_parity_popup,'sel_parity');
comport = strcat('COM',get(handles.comset_com_adress_edit,'String'));
stopbit = str2double(get(handles.comset_stop_edit,'String'));
databit = str2double(get(handles.comset_data_edit,'String'));

% Open serial port
open_serial_port( comport, baudrate, databit, parity, stopbit );

waitbar(2/4,h)
% Indicate connection status in the gui with a color change to green
set(handles.status_con_status,'BackgroundColor',[0 1 0]);
set(handles.status_con_status,'String','Verbunden');

% Check connection quality
device_id = get(handles.comset_device_id_text,'String');
request_list = {'quality'};

% Receive the quality signal 
request_value = read_sr(device_id, request_list, hObject, handles);

if isempty(request_value)
    close(h)
    errordlg('Communication quality could not be determined as no data has been received after request','Communication error');
    return;
else
    waitbar(3/4,h)
    % Displays the signal quality in a bar plot
%     bar(handles.status_con_quality_bar,(0:request_value),(0:request_value),'r');    
%     evalin('base','hold on');
    if request_value < 9
    bar(handles.status_con_quality_bar,(request_value+1:9),(request_value+1:9),'w');
    end
    hold(handles.status_con_quality_bar);
    bar(handles.status_con_quality_bar,(0:request_value),(0:request_value),'r');
    set(handles.status_con_quality_bar,'XLim',[-0.5 10]);
    set(handles.status_con_quality_bar,'YLim',[0 10]);
    set(handles.status_con_quality_bar,'XTickLabelMode','Manual');
    set(handles.status_con_quality_bar,'XTick',[]);
    set(handles.status_con_quality_bar,'YTickLabelMode','Manual');
    set(handles.status_con_quality_bar,'YTick',[]);

    hold off;
    
    waitbar(4/4,h)
    % Changes Backgroundcolor of quality text in GUI
    if request_value >= 5
        set(handles.status_con_quality_text,'Backgroundcolor',[0 1 0]);
    end 
    
    close(h)
end


function comset_temp_offset_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_temp_offset_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_temp_offset_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_temp_offset_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_temp_offset_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_temp_offset_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comset_utc_offset_edit_Callback(hObject, eventdata, handles)
% hObject    handle to comset_utc_offset_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comset_utc_offset_edit as text
%        str2double(get(hObject,'String')) returns contents of comset_utc_offset_edit as a double


% --- Executes during object creation, after setting all properties.
function comset_utc_offset_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_utc_offset_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in comset_settings_button.
function comset_settings_button_Callback(hObject, eventdata, handles)

% Check whether serial interface is established and data structure is in
% workspace available
serial_interface_check();
data_struct_check();

% Get values from edit box
station = dec2hex(str2double(get(handles.comset_station_edit,'String')),4);
city_id = dec2hex(getappdata(handles.comset_city_id_popup,'city_id'),4);
temp_offset = dec2hex(str2double(get(handles.comset_temp_offset_edit,'String')),4);
utc_offset = str2double(get(handles.comset_utc_offset_edit,'String'));
device_id = dec2hex(str2double(get(handles.comset_device_id_edit,'String')),2);

% Values to be written to the single registers
reg_value_list = {station, city_id, temp_offset, device_id};

% Registers to be written to
reg_add_list = {'transmitting_station', 'city_id', 'temperature_offset'};

% Write operation
write_sr(reg_value_list, reg_add_list, hObject, handles);

% Read registers and display actual values in GUI
comset_disp_act_values_button_Callback(hObject, eventdata, handles);

% --- Executes on button press in comset_reset_button.
function comset_reset_button_Callback(hObject, eventdata, handles)

% Check whether serial interface is established and data structure is in
% workspace available
serial_interface_check();
data_struct_check();

set(handles.comset_station_edit,'String','1');
set(handles.comset_city_id_popup,'Value',587);
set(handles.comset_temp_offset_edit,'String','0');
set(handles.comset_utc_offset_edit,'String','0');
set(handles.comset_device_id_edit,'String','03');

station = dec2hex(str2double(get(handles.comset_station_edit,'String')),4);
city_id = dec2hex(353,4);
temp_offset = dec2hex(str2double(get(handles.comset_temp_offset_edit,'String')),4);
utc_offset = str2double(get(handles.comset_utc_offset_edit,'String'));
device_id = dec2hex(str2double(get(handles.comset_device_id_edit,'String')),2);

% Values to be written to the single registers
reg_value_list = {station, city_id, temp_offset, device_id};

% Registers to be written to
reg_add_list = {'transmitting_station', 'city_id', 'temperature_offset'};

% Write operation
write_sr(reg_value_list, reg_add_list, hObject, handles);

% Read registers and display actual values in GUI
comset_disp_act_values_button_Callback(hObject, eventdata, handles);

% --- Executes on selection change in com_protocol_listbox.
function com_protocol_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to com_protocol_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns com_protocol_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from com_protocol_listbox


% --- Executes during object creation, after setting all properties.
function com_protocol_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_protocol_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in com_protocol_clear_list_button.
function com_protocol_clear_list_button_Callback(hObject, eventdata, handles)

% Set the header for the protocol listbox
header = sprintf('%s %s','Communication protocol: ',datestr(now));
set(handles.com_protocol_listbox,'String',header);

% --- Executes on button press in comset_disp_act_values_button.
function comset_disp_act_values_button_Callback(hObject, eventdata, handles)

% Check if serial interface is established and data struct is available in
% workspace
serial_interface_check();
data_struct_check();

% Receive device id from edit field, define request list 
device_id = get(handles.comset_device_id_text,'String');
request_list = {'temperature_offset', 'city_id', 'transmitting_station', 'temperature'};  

request_value = read_sr(device_id, request_list, hObject, handles);

% Update text fields in the gui
set(handles.comset_temp_offset_value,'String',num2str(request_value(1)));
set(handles.comset_city_id_value,'String',num2str(request_value(2)));
set(handles.comset_station_value,'String',num2str(request_value(3)));
set(handles.comset_local_temperature_value,'String',num2str(request_value(4)/10));

guidata(hObject,handles);



% --- Executes on selection change in comset_city_id_popup.
function comset_city_id_popup_Callback(hObject, eventdata, handles)
% hObject    handle to comset_city_id_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comset_city_id_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comset_city_id_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_city_name = string_list{val};
city_id = get_city_id(selected_city_name);
setappdata(handles.comset_city_id_popup,'city_id',city_id);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function comset_city_id_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comset_city_id_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in single_request_msg_gen_button.
function single_request_msg_gen_button_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_msg_gen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data_struct_check();

% Popup Auswahl ermitteln
prog_scope = getappdata(handles.single_request_progscope_popup,'sel_progscope');
if strcmp(prog_scope,'Luftdruck') == 1 || strcmp(prog_scope,'Signifikantes_Wetter') == 1
    prog_detail = [];
else
    prog_detail = getappdata(handles.single_request_progdetail_popup,'sel_progdetail');
end
prog_day = getappdata(handles.single_request_progday_popup,'sel_from_progday');
prog_hour = getappdata(handles.single_request_proghour_popup,'sel_from_proghour');

% Argumente bündeln
popup_scope_detail = {prog_scope, prog_detail};
popup_date = {prog_day, prog_hour};

% Registeraddressen ermitteln
[start_reg_address, field_name] = get_reg_address(popup_scope_detail, popup_date);
end_reg_address = start_reg_address;

device_address = dec2hex(str2num(get(handles.comset_device_id_edit,'String')),2);
setappdata(handles.comset_device_id_edit,'dev_address',device_address);

func_code = dec2hex(3,2);

% Überprüfung ob Intervall-Werte richtig ausgewählt wurden
[quantity_reg_addresses] = input_check(start_reg_address, end_reg_address, func_code, device_address);

% Modbus Nachricht zusammensetzen
modbus_msg = strcat(device_address,func_code,start_reg_address,quantity_reg_addresses);
set(handles.single_request_msg_edit,'String',modbus_msg);

% CRC Summe berechnen und komplette Nachricht ausgeben
[modbus_msg_crc] = crc_calc(modbus_msg);
setappdata(handles.single_request_msg_edit,'modbus_msg_crc',modbus_msg_crc);
value = '-';
table_data_single = {popup_scope_detail{1}, popup_scope_detail{2}, strcat(popup_date{1},'-',popup_date{2}), modbus_msg_crc, value}; 
setappdata(handles.single_request_msg_gen_button,'table_data_single',table_data_single);
drawnow;


function single_request_response_edit_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_response_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of single_request_response_edit as text
%        str2double(get(hObject,'String')) returns contents of single_request_response_edit as a double


% --- Executes during object creation, after setting all properties.
function single_request_response_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_response_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in single_request_add_response_button.
function single_request_add_response_button_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_add_response_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table_data_single = get(handles.single_request_response_table, 'Data');
add_table_data_single = getappdata(handles.single_request_response_table,'table_data_single');
if isempty(table_data_single) == 1
    set(handles.single_request_response_table,'Data',add_table_data_single);
else
    if isempty(table_data_single{1}) == 1 
        set(handles.single_request_response_table,'Data',add_table_data_single);
    else
        table_data_single = [table_data_single; add_table_data_single];
        set(handles.single_request_response_table,'Data',table_data_single);
    end
end
set(handles.single_request_response_table,'ColumnWidth',{100 100 150 150 110 80});
drawnow;


% --- Executes on button press in single_request_remove_response.
function single_request_remove_response_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_remove_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_row = getappdata(handles.single_request_response_table,'SelRow');
table_data_single = get(handles.single_request_response_table, 'Data');
table_data_single(selected_row,:)=[];
set(handles.single_request_response_table,'Data',table_data_single);
drawnow;

% --- Executes on button press in single_request_save_response.
function single_request_save_response_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_save_response (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in single_request_remove_all_responses.
function single_request_remove_all_responses_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_remove_all_responses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

table_data_single = get(handles.single_request_response_table, 'Data');
table_data_single(:,:)=[];
set(handles.single_request_response_table,'Data',table_data_single);
drawnow;

% --- Executes on selection change in single_request_updateint_popup.
function single_request_updateint_popup_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_updateint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns single_request_updateint_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from single_request_updateint_popup


% --- Executes during object creation, after setting all properties.
function single_request_updateint_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_updateint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in single_request_progupdate_checkbox.
function single_request_progupdate_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_progupdate_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of single_request_progupdate_checkbox


% --- Executes on selection change in single_request_progscope_popup.
function single_request_progscope_popup_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns single_request_progscope_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from single_request_progscope_popup
set(handles.single_request_progday_popup,'Value',1);
set(handles.single_request_proghour_popup,'Value',1);

val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_prog_scope = string_list{val};
setappdata(handles.single_request_progscope_popup,'sel_progscope',selected_string_prog_scope);
switch selected_string_prog_scope
    case 'Luftdruck'
        Ld = getappdata(handles.single_request_progscope_popup,'Luftdruck');
        set(handles.single_request_progdetail_popup,'String',Ld);
        Ld_day = getappdata(handles.single_request_progday_popup,'erste_Auspraegung');
        set(handles.single_request_progday_popup,'String',Ld_day);
    case 'Markantes_Wetter'
        mW = getappdata(handles.single_request_progscope_popup,'Markantes_Wetter');
        set(handles.single_request_progdetail_popup,'String',mW);
        mW_day = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
        set(handles.single_request_progday_popup,'String',mW_day);
    case 'Niederschlag'
        niederschlag = getappdata(handles.single_request_progscope_popup,'Niederschlag');
        set(handles.single_request_progdetail_popup,'String',niederschlag);
        niederschlag_day = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
        set(handles.single_request_progday_popup,'String',niederschlag_day);
    case 'Signifikantes_Wetter'
        sW = getappdata(handles.single_request_progscope_popup,'Signifikantes_Wetter');
        set(handles.single_request_progdetail_popup,'String',sW);
        sW_day = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
        set(handles.single_request_progday_popup,'String',sW_day);
    case 'Solarleistung'
        solarP = getappdata(handles.single_request_progscope_popup,'Solarleistung');
        set(handles.single_request_progdetail_popup,'String',solarP);
        solarP_day = getappdata(handles.single_request_progday_popup,'erste_Auspraegung');
        set(handles.single_request_progday_popup,'String',solarP_day);
    case 'Temperatur'
        tmp = getappdata(handles.single_request_progscope_popup,'Temperatur');
        set(handles.single_request_progdetail_popup,'String',tmp);
        tmp_day = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
        set(handles.single_request_progday_popup,'String',tmp_day);
    case 'Wind'
        wind = getappdata(handles.single_request_progscope_popup,'Wind');
        set(handles.single_request_progdetail_popup,'String',wind);
        wind_day = getappdata(handles.single_request_progday_popup,'zweite_Auspraegung');
        set(handles.single_request_progday_popup,'String',wind_day);
    otherwise
end


% --- Executes during object creation, after setting all properties.
function single_request_progscope_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_progscope_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in single_request_progdetail_popup.
function single_request_progdetail_popup_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_progdetail_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns single_request_progdetail_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from single_request_progdetail_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_progdetail = string_list{val};
setappdata(handles.single_request_progdetail_popup,'sel_progdetail',selected_string_progdetail);
eAf = getappdata(handles.multi_request_from_proghour_popup,'erste_Auspraegung'); 
zAf = getappdata(handles.multi_request_from_proghour_popup,'zweite_Auspraegung');
switch selected_string_progdetail
    case 'Mittlere_temp_prog'
        set(handles.single_request_proghour_popup,'String',eAf);
    otherwise
        set(handles.single_request_proghour_popup,'String',zAf);
end


% --- Executes during object creation, after setting all properties.
function single_request_progdetail_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_progdetail_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in single_request_progday_popup.
function single_request_progday_popup_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_progday_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns single_request_progday_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from single_request_progday_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_progday = string_list{val};
setappdata(handles.single_request_progday_popup,'sel_from_progday',selected_string_progday);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function single_request_progday_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_progday_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in single_request_proghour_popup.
function single_request_proghour_popup_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_proghour_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns single_request_proghour_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from single_request_proghour_popup
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string_proghour = string_list{val};
setappdata(handles.single_request_proghour_popup,'sel_from_proghour',selected_string_proghour);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function single_request_proghour_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_proghour_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function single_request_msg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_msg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of single_request_msg_edit as text
%        str2double(get(hObject,'String')) returns contents of single_request_msg_edit as a double


% --- Executes during object creation, after setting all properties.
function single_request_msg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_request_msg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in single_request_send_button.
function single_request_send_button_Callback(hObject, eventdata, handles)
% hObject    handle to single_request_send_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
serial_interface_check();
data_struct_check();

msg = getappdata(handles.single_request_msg_edit,'modbus_msg_crc');
field_name = getappdata(handles.single_request_msg_gen_button,'table_data_single');
field_name = {field_name{1} field_name{2} field_name{3}};
[ txdata ] = send_and_receive_data(msg, field_name, hObject, handles, '');
table_data_single = getappdata(handles.single_request_msg_gen_button,'table_data_single');
table_data_single{5} = txdata;
set(handles.single_request_response_edit,'String',table_data_single{5});
setappdata(handles.single_request_response_table,'table_data_single',table_data_single);



% --- Executes when selected cell(s) is changed in single_request_response_table.
function single_request_response_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to single_request_response_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
selected_cells = eventdata.Indices;
setappdata(handles.single_request_response_table,'SelRow',selected_cells(1));



function multi_request_start_date_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_start_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multi_request_start_date as text
%        str2double(get(hObject,'String')) returns contents of multi_request_start_date as a double


% --- Executes during object creation, after setting all properties.
function multi_request_start_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_start_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multi_request_end_date_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_end_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multi_request_end_date as text
%        str2double(get(hObject,'String')) returns contents of multi_request_end_date as a double


% --- Executes during object creation, after setting all properties.
function multi_request_end_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_end_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multi_request_resolution_Callback(hObject, eventdata, handles)
% hObject    handle to multi_request_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multi_request_resolution as text
%        str2double(get(hObject,'String')) returns contents of multi_request_resolution as a double


% --- Executes during object creation, after setting all properties.
function multi_request_resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multi_request_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
