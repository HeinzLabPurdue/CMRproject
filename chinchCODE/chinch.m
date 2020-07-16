function varargout = chinch(varargin)
%BOTTOM CHAMBER - Jan 10, 2020
%BOTTOM CHAMBER - August 4, 2017
%03202018 ACM copied bottom code to correct the mistakes made in the top
%code when getting top booth back up in running order.  Now this is for TOP chamber and runs and aborts out of blocks.
%Also has summaries at the end of the .DAT files
%
% 120619 - MH/AM - changing RP to RP_bot everwhere for ActiveXobject to
% keep clear of other chamber
% 121319 - MH/AM - cleaning up code to modernize all ActiveX calls
%
% CHINCH M-file for chinch.fig
%      CHINCH, by itself, creates a new CHINCH or raises the existing
%      singleton*.
%
%      H = CHINCH returns the handle to a new CHINCH or the handle to
%      the existing singleton*.
%
%      CHINCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHINCH.M with the given input arguments.
%
%      CHINCH('Property','Value',...) creates a new CHINCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chinch_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to chinch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chinch
% Last Modified by GUIDE v2.5 21-Feb-2007 11:59:25

%% %%%%%
% M.Heinz - setting up DEBUG_emulate version to allow offline (no TDT)
% debugging
global DEBUG_emulate
DEBUG_emulate = 1; % 1: not connected to TDT; 0: yes connected to TDT'


global DEBUG_trialDisplay
DEBUG_trialDisplay = 0; %Displays trial type in the command line before each trial runs

%% %%%%%
% Modified 5-Sept-2013 by AEH
% Modified 11-02-2015 edited MKW(see line 1322)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @chinch_OpeningFcn, ...
    'gui_OutputFcn',  @chinch_OutputFcn, ...
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


% --- Executes just before chinch is made visible.
function chinch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output_file args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chinch (see VARARGIN)

% Choose default command line output_file for chinch
handles.output = hObject;

device_update(handles.device, handles.interface, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chinch wait for user response (see UIRESUME)
% uiwait(handles.chinch);


% --- Outputs from this function are returned to the command line.
function varargout = chinch_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output_file args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output_file from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exit.
function exit_Callback(~, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chinch_CloseRequestFcn(handles.chinch, eventdata, handles);

% --- Executes when user attempts to close chinch.
function chinch_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to chinch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

if strcmp(questdlg('Are you sure you want to quit?', ...
        'Exiting experiment', 'No'), 'Yes')
    delete(hObject);
end




% --- Executes on selection change in interface.
function interface_Callback(hObject, eventdata, handles)
% hObject    handle to interface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns interface contents as cell array
%        contents{get(hObject,'Value')} returns selected item from interface

uiupdate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function interface_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

interfaces = {'USB'};
% interfaces = {'GB'};

%  % Commenting this all OUT 12/13/19 - MH/AM - we know it's USB!!
% interfaces = {'GB' 'USB'};
% zbus_bot = actxcontrol('ZBUS.x', [0 0 0 0]);
% for i = length(interfaces):-1:1
%     if ~zbus_bot.ConnectZBUS(interfaces{i})
%         interfaces(i) = [];
%     end
% end
%
% % Changed - MH/AM 11/11/2019 due to new PC having trouble with this command
% % (and old PC few time over weekend
% if isempty(interfaces)
%     interfaces = {'USB'};
%     disp(sprintf('USB Connection HardCoded due to zbus_bot.ConnectZBUS(interfaces{i})   error.\n***Should be OK for now.'))
% %     waitfor(errordlg({'USB Connection HardCoded due to zbus_bot.ConnectZBUS(interfaces{i})   error.', ...
% %             'Should be OK for now.'}, ...
% %             'Connection error', 'nonmodal'));
%     %     waitfor(errordlg({'Unable to connect to an interface.', ...
%     %         'Please make sure power is on.'}, ...
%     %         'Connection error', 'modal'));
% end

if length(interfaces) == 1
    set(hObject, 'String', interfaces)
else
    set(hObject, 'String', [{'Select'} interfaces]);
end
% delete(zbus_bot);

% --- Executes on selection change in device.
function device_Callback(hObject, eventdata, handles)
% hObject    handle to device (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns device contents as cell array
%        contents{get(hObject,'Value')} returns selected item from device

uiupdate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function device_CreateFcn(hObject, eventdata, handles)
% hObject    handle to device (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global DEBUG_emulate

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.DEBUG_emulate = DEBUG_emulate;

if ~handles.DEBUG_emulate
    handles.RP_bot = actxcontrol('RPco.x', [0 0 0 0]);
else
    handles.RP_bot = '';
end

% MH/AM Jan 10 2020:  continue to try until connected (in case of glitch
% failures)
testCON_RP_bot=0;
while ~testCON_RP_bot
    if ~handles.DEBUG_emulate
        testCON_RP_bot = handles.RP_bot.ConnectRP2('USB',2)  %12/13/19 - put in here to confirm NO connect
    else
        testCON_RP_bot = 1;
    end
    if ~testCON_RP_bot
        disp('FAILED TDT connection (Device #2), re-trying ...')
    else
        disp('TDT connection SUCCESSFUL')
    end
end
guidata(hObject, handles);

function uiupdate(hObject, eventdata, handles)

fn = fieldnames(handles);
for i = 1:length(fn)
    handle = getfield(handles, fn{i});
    try
        eval([get(handle, 'Tag') '_update(handle, hObject, handles)']);
    catch
    end
end

function device_update(hObject, eventdata, handles)

if eventdata == handles.interface
    interface = get_interface(handles);
    if isempty(interface)
        set(hObject, 'Enable', 'off', 'Value', 1)
    else
        %         devices = {'RA16', 'RL2', 'RM1', 'RM2', 'RP2', 'RV8', ...
        %             'RX5', 'RX6', 'RX7', 'RX8'};
        %         for i = length(devices):-1:1
        %             if ~invoke(handles.RP_bot, ['Connect' devices{i}], interface, 2)
        %                 devices(i) = [];
        %             end
        %         end
        devices = {'RP2'};
        if isempty(devices)
            errordlg({'There are no devices attached to this interface.', ...
                'Ensure power is on.'}, ...
                'Unable to detect devices', 'modal');
            set(hObject, 'Enable', 'off', 'Value', 1);
        elseif length(devices) == 1
            set(hObject, 'Enable', 'on', 'String', devices);
            device_number_update(handles.device_number, hObject, handles);
        else
            set(hObject, 'Enable', 'on', 'String', [{'Select'} devices]);
        end
    end
else
    running_enable(hObject, handles);
end


% --- Executes on selection change in device_number.
function device_number_Callback(hObject, eventdata, handles)
% hObject    handle to device_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns device_number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from device_number

value = get(hObject, 'Value');
if value ~= 1
    %     device = get_device(handles);
    interface = get_interface(handles);
    device_number = value - 1;
    if ~handles.DEBUG_emulate
        if ~handles.RP_bot.ConnectRP2(interface,device_number)
            %     if ~invoke(handles.RP_bot, ['Connect' device], interface, device_number)
            errordlg('Cannot connect to device')
        else
            uiupdate(hObject, eventdata, handles)
        end
    else
        uiupdate(hObject, eventdata, handles)
    end
end

% --- Executes during object creation, after setting all properties.
function device_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to device_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function device_number_update(hObject, eventdata, handles)

if running(handles)
    set(hObject, 'Enable', 'off')
elseif isempty(get_interface(handles)) || isempty(get_device(handles))
    set(hObject, 'Enable', 'off', 'Value', 1);
elseif eventdata == handles.device
    
    % M. Heinz - Aug 4, 2017
    %
    % Hard Coded CHAMBER to set device number (ASSUMES TOP turned on 1st,
    % bottom turned on 2nd)
    % Saves device number in GUI - rather than Select - no option to Select
    % Removed "Select feature, which had error horzcat error anyway.
    
    %     CHAMBER='TOP'
    CHAMBER='BOTTOM'
    
    if strcmp(CHAMBER,'TOP')
        set(hObject, 'Enable', 'on', 'String', '1');
    elseif strcmp(CHAMBER,'BOTTOM')
        set(hObject, 'Enable', 'on', 'String', '2');
    else
        errordlg('CHAMBER must be "TOP" or "BOTTOM"')
    end
    
    %     interface = get_interface(handles);
    %     device = get_device(handles);
    %     for highest_device = 1:16
    %         if ~invoke(handles.RP_bot, ['Connect' device], interface, highest_device)
    %             break
    %         end
    %     end
    %     highest_device = highest_device - 1;
    %     if highest_device == 1
    %         set(hObject, 'Enable', 'on', 'String', '1');
    %     else
    %         selection = [{'Select'} cellstr(num2str((1:highest_device)'))];
    %         set(hObject, 'Enable', 'on');
    %         set(hObject, 'String', selection);
    %     end
else
    set(hObject, 'Enable', 'on');
end

function i = get_interface(handles)

value = get(handles.interface, 'Value');
string = get(handles.interface, 'String');
i = string{value};
if strcmp(i, 'Select')
    i = '';
end

function d = get_device(handles)

value = get(handles.device, 'Value');
string = get(handles.device, 'String');
d = string{value};
if strcmp(d, 'Select')
    d = '';
end

function d = get_device_number(handles)

value = get(handles.device_number, 'Value');
string = get(handles.device_number, 'String');
if iscellstr(string)
    d = str2num(string{value});
else
    d = str2num(string);
end
if isempty(d)
    d = 0;
end

% --- Executes during object creation, after setting all properties.
function chinch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chinch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

waitfor(msgbox({'Welcome to the MATLAB interactive chinchilla program', ...
    'You may use the TAB key to move through the options', ...
    'on the following screen.', ...
    'Press "Accept", then "Run" when you are ready.'}, 'Welcome', 'modal'));

% --- Executes on selection change in ID.
function ID_Callback(hObject, eventdata, handles)
% hObject    handle to ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ID

uiupdate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

filename = 'CHINCH.DAT';
fid = fopen(filename, 'rt');
if fid == -1
    errordlg(sprintf('Cannot find %s', filename), 'modal')
else
    names = {};
    while ~feof(fid)
        line= '';
        while (isempty(line) || strcmp(line, '*')) && ~feof(fid)
            line = deblank(fgetl(fid));
        end
        if feof(fid)
            break
        end
        names{end+1} = sscanf(line, '%s');
        line = '';
        while ~strcmp(line, '*') && ~feof(fid)
            line = deblank(fgetl(fid));
        end
    end
    if isempty(names)
        errordlg(sprintf('There are no chincilla names in %s', filename), 'modal');
    else
        set(hObject, 'String', [{'Select'} names]);
    end
    fclose(fid);
end

function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double

weight = get_weight(handles);
if weight <= 0
    set(hObject, 'String', '***** (g)');
else
    set(hObject, 'String', sprintf('%g (g)', weight));
end
uiupdate(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pct_free_feed_Callback(hObject, eventdata, handles)
% hObject    handle to pct_free_feed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pct_free_feed as text
%        str2double(get(hObject,'String')) returns contents of pct_free_feed as a double


% --- Executes during object creation, after setting all properties.
function pct_free_feed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pct_free_feed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [id, value] = get_id(handles)

value = get(handles.ID, 'Value');
if value == 1
    id = '';
else
    ids = get(handles.ID, 'String');
    id = ids{value};
end

function weight_update(hObject, eventdata, handles)

if eventdata == handles.ID
    set(hObject, 'String', '')
end

if ~isempty(get_id(handles)) && ~accepted(handles)
    set(hObject, 'Enable', 'on');
else
    set(hObject, 'Enable', 'off');
end

function pct_free_feed_update(hObject, eventdata, handles)

accepted_enable(hObject, handles, 'inactive');

if eventdata == handles.ID
    set(hObject, 'String', '??.?? %');
    if isempty(get_id(handles))
        set(hObject, 'Enable', 'off');
    else
        set(hObject, 'Enable', 'inactive');
    end
elseif eventdata == handles.weight
    set(hObject, 'Enable', 'inactive');
    weight = get_weight(handles);
    if weight < 0
        set(hObject, 'String', '??.?? %');
    else
        fid = fopen('CHINCH.DAT', 'rt');
        line = '';
        id = get_id(handles);
        while ~strcmp(line, id)
            line = sscanf(fgetl(fid), '%s');
        end
        [ff count] = sscanf(fgetl(fid), '%f');
        if count == 0
            errordlg('Unable to read free feed weight', 'modal');
        else
            set(hObject, 'String', sprintf('%.2f %%', weight/ff*100));
        end
        fclose(fid);
    end
end

function weight = get_weight(handles)

[weight count] = sscanf(get(handles.weight, 'String'), '%f');
if count ~= 1
    weight = -1;
end



function np_Callback(hObject, eventdata, handles)
% hObject    handle to np (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of np as text
%        str2double(get(hObject,'String')) returns contents of np as a double


% --- Executes during object creation, after setting all properties.
function np_CreateFcn(hObject, eventdata, handles)
% hObject    handle to np (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function reps_Callback(hObject, eventdata, handles)
% hObject    handle to reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reps as text
%        str2double(get(hObject,'String')) returns contents of reps as a double


% --- Executes during object creation, after setting all properties.
function reps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbt_Callback(hObject, eventdata, handles)
% hObject    handle to tbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbt as text
%        str2double(get(hObject,'String')) returns contents of tbt as a double

tbt = get_tbt(handles);
if tbt < 0
    set(hObject, 'String', '***** s');
else
    set(hObject, 'String', sprintf('%.2f s', tbt));
end


% --- Executes during object creation, after setting all properties.
function tbt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function buz_Callback(hObject, eventdata, handles)
% hObject    handle to buz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of buz as text
%        str2double(get(hObject,'String')) returns contents of buz as a double

dur = get_buz(handles);
if dur < 0
    set(hObject, 'String', '***** s');
else
    set(hObject, 'String', sprintf('%.2f s', dur));
end

% --- Executes during object creation, after setting all properties.
function buz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tto_Callback(hObject, eventdata, handles)
% hObject    handle to tto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tto as text
%        str2double(get(hObject,'String')) returns contents of tto as a double

dur = get_tto(handles);
if dur < 0
    set(hObject, 'String', '***** s');
else
    set(hObject, 'String', sprintf('%.2f s', dur));
end

% --- Executes during object creation, after setting all properties.
function tto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function reinforce_Callback(hObject, eventdata, handles)
% hObject    handle to reinforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reinforce as text
%        str2double(get(hObject,'String')) returns contents of reinforce as a double

pct = round(get_reinforce(handles));
if pct < 0 | pct > 100
    set(hObject, 'String', '***** %');
else
    pct = round(100/(100 - pct));
    pct = 100 - round(100/pct);
    set(hObject, 'String', sprintf('%d %%', pct));
end

function VIR = get_VIR(handles,varargin)

pct = get_reinforce(handles);
if ~isempty(varargin) % AEH added to build in 80% VIR for some tests
    pct = varargin{1};
end
if pct == 100
    VIR = -1;
else
    %     VIR = round(100/(100-pct));
    % AEH modified 140520
    % count number of possible Hits (# signal trials)
    for tempindx = 1:length(handles.stmlist)
        temp(tempindx) = handles.stmlist(tempindx).test;
    end
    numPossHits = sum(temp);
    eonum = ceil(pct/100*numPossHits);
    eonum = floor(numPossHits/(numPossHits-eonum));
    VIR = eonum;
end

% --- Executes during object creation, after setting all properties.
function reinforce_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reinforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_file_Callback(hObject, eventdata, handles)
% hObject    handle to output_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_file as text
%        str2double(get(hObject,'String')) returns contents of output_file as a double


% --- Executes during object creation, after setting all properties.
function output_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_file.
function select_file_Callback(hObject, eventdata, handles)
% hObject    handle to select_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in rove.
function rove_Callback(hObject, eventdata, handles)
% hObject    handle to rove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rove


% --- Executes on button press in replace.
function replace_Callback(hObject, eventdata, handles)
% hObject    handle to replace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of replace



function first_atten_Callback(hObject, eventdata, handles)
% hObject    handle to first_atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of first_atten as text
%        str2double(get(hObject,'String')) returns contents of first_atten as a double


% --- Executes during object creation, after setting all properties.
function first_atten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to first_atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function second_atten_Callback(hObject, eventdata, handles)
% hObject    handle to second_atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of second_atten as text
%        str2double(get(hObject,'String')) returns contents of second_atten as a double


% --- Executes during object creation, after setting all properties.
function second_atten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to second_atten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tbt = get_tbt(handles)

[tbt count] = sscanf(get(handles.tbt, 'String'), '%f');
if count ~= 1
    tbt = -1;
end

function dur = get_buz(handles)

[dur count] = sscanf(get(handles.buz, 'String'), '%f');
if count ~= 1
    dur = -1;
end

function dur = get_tto(handles)

[dur count] = sscanf(get(handles.tto, 'String'), '%f');
if count ~= 1
    dur = -1;
end

function pct = get_reinforce(handles)

[pct count] = sscanf(get(handles.reinforce, 'String'), '%f');
if count ~= 1
    pct = -1;
end



function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double


% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', datestr(now, 26));


function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', datestr(now, 15))


% --- Executes during object creation, after setting all properties.
function rove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function replace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to replace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function atten1_Callback(hObject, eventdata, handles)
% hObject    handle to atten1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of atten1 as text
%        str2double(get(hObject,'String')) returns contents of atten1 as a double

atten = round(get_atten1(handles));
if isnan(atten)
    set(hObject, 'String', '***** dB');
else
    set(hObject, 'String', sprintf('%d dB', atten));
end

% --- Executes during object creation, after setting all properties.
function atten1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atten1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function atten2_Callback(hObject, eventdata, handles)
% hObject    handle to atten2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of atten2 as text
%        str2double(get(hObject,'String')) returns contents of atten2 as a double

atten = round(get_atten2(handles));
if isnan(atten)
    set(hObject, 'String', '***** dB');
else
    set(hObject, 'String', sprintf('%d dB', atten));
end

% --- Executes during object creation, after setting all properties.
function atten2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atten2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function np = get_np(handles)

np = get(handles.np, 'String');
if iscellstr(np)
    np = np{get(handles.np, 'Value')};
    if strcmp(np, 'Select')
        np = '';
    end
end

function reps = get_reps(handles)

s = get(handles.reps, 'String');
v = get(handles.reps, 'Value');
reps = str2num(s{v});

function rove = get_rove(handles)

rove = get(handles.rove, 'Value') == 2;

function replace = get_replace(handles)

replace = get(handles.replace, 'Value') == 2;

function clear_output_file(handles)

set(handles.output_file, 'String', '', 'UserData', '');
guidata(gcbf, handles);

function filename = get_output_file(handles)

filename = get(handles.output_file, 'String');
if isempty(filename)
    return
end
pathname = get(handles.output_file, 'UserData');
filename = fullfile(pathname, filename);

function atten = get_atten1(handles)

[atten count] = sscanf(get(handles.atten1, 'String'), '%f');
if count ~= 1
    atten = NaN;
end

function atten = get_atten2(handles)

[atten count] = sscanf(get(handles.atten2, 'String'), '%f');
if count ~= 1
    atten = NaN;
end


% --- Executes on button press in output_select.
function output_select_Callback(hObject, eventdata, handles)
% hObject    handle to output_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

id = get_id(handles);
directory = [id 'DATA'];
if ~exist(directory, 'dir')
    errordlg(sprintf('Directory %s does not exist', directory));
    return
end
[filename pathname] = uiputfile(fullfile(directory, '*.DAT'), 'Save Data File');
if isequal(filename, 0)
    set(handles.output_file, 'String', '', 'UserData', '');
else
    set(handles.output_file, 'String', filename, 'UserData', pathname);
end

function a = running(handles)
a = strcmp(get(handles.run, 'String'), 'Abort');

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% AEH added this section to differentiate between
% conditions with only .same trials and
% conditions with both .same and .test trials
for tempindx = 1:length(handles.stmlist)
    temp(tempindx) = handles.stmlist(tempindx).same;
end
if any(temp==1) % there are test and same trials
    ScoreFlag = 1;
else % there are only test trials
    ScoreFlag = 0;
end

% AEH added to count #pellets delivered during test
reward_count = 0;

% AEH edit
global mancount
global animpresscount
global magtraincount
global nplayfromfile
global DEBUG_trialDisplay

if ~running(handles)
    if get_device_number(handles) == 0
        errordlg('You must select a device')
    else
        if ~handles.DEBUG_emulate
            if ~handles.RP_bot.Run
                waitfor(errordlg('Unable to run device.', 'Device error', 'modal'))
                return
            end
        end
        
        
        if getbar(handles)
            waitfor(warndlg('Make sure device panel is switched on', 'Power to device panel?', 'modal'))
        end
        
        % AEH 12/12/13: Pellet dispenser test is optional
        % (so that extra pellets are not dispensed between different tests)
        testdisp = 0;
        switch questdlg('Would you like to test the pellet dispenser?', 'Dispenser check')
            case 'Cancel'
                if ~handles.DEBUG_emulate
                    handles.RP_bot.Halt;
                end
                return
            case 'Yes'
                testdisp = 1;
        end
        while testdisp %logical(1)
            reinforce(handles);
            switch questdlg('Is there a pellet in the dispenser?', 'Dispenser check')
                case 'Cancel'
                    if ~handles.DEBUG_emulate
                        handles.RP_bot.Halt;
                    end
                    return
                case 'Yes'
                    break
            end
        end
        
        set(hObject, 'String', 'Abort', 'ForeGroundColor', 'b')
        uiupdate(hObject, eventdata, handles);
        set(handles.output_log, 'String', {'Tr St    fileA ISI    fileB N Re Time'; ...
            '-- -- -------- --- -------- - -- ----'});
        reps = get_reps(handles);
        npidx = [];
        reinforce_count = 0;
        % AEH build in 80% VIR for certain tests (added 140627)
        % (requires no change to GUI for experimenter)
        if ScoreFlag==1 % any tests with signal AND catch trials
            newpct = 90;
            %newpct = 80;
            VIR = get_VIR(handles,newpct);
        else
            VIR = get_VIR(handles);
        end
        
        % MH/AM Jan 9 2020 - sometimes get Jibberish from GSFreq, so need
        % to confirm valid answer.
        TDT_srates=48828*[1/4 1/2 1 2]; %standard TDT Srates
        fs_TDT=-999;
        while isempty(find(round(fs_TDT)==TDT_srates))
            if ~handles.DEBUG_emulate
                fs_TDT = handles.RP_bot.GetSFreq;
            else
                fs_TDT = 48828;
            end
        end
        %         fprintf('TDT Sampling Freq = %.f Hz\n',round(fs_TDT))
        handles.fs_TDT=fs_TDT; % for use in declare_sound_files functions to avoid extra calls to TDT to GetSFreq
        
        replace_errors = get_replace(handles);
        replace_trial = logical(0);
        tbt = get_tbt(handles);
        tto = get_tto(handles);
        
        Hts = 0; adj_Hts = 0;
        Mss = 0; adj_Mss = 0;
        CRs = 0; adj_CRs = 0;
        FAs = 0; adj_FAs = 0;
        Abs = 0; adj_Abs = 0;
        tic
        t = 0;
        
        %         % AEH edit
        %         global mancount
        %         global animpresscount
        %         global magtraincount
        %         global nplayfromfile
        mancount = 0; % AEH
        animpresscount = 0; % AEH
        magtraincount = 0; % AEH
        nplayfromfile = max(handles.nplist); % needed below in np results: setfield, getfield
        stimdatacount = 1;
        
        np_results = repmat(struct('Ab', 0, 'Ht', 0, 'Ms', 0, 'CR', 0, 'FA', 0), length(handles.nplist), 1);
        targets = get_target_reps(handles);
        
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         % JUST FOR playing tone to SR1
        %                 targets = 100000;
        %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %         if targets == 0 % AEH commented out this section 130909
        %             targets = 3;
        %             bbb = logical(1);
        %         else
        %             bbb = logical(0);
        %         end
        %         handles.RP_bot.SetTagVal('BBB', bbb);
        
        
        for trial = 1:reps
            if ~running(handles)
                break
            end
            handles = shuffle(hObject,handles);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% AEH modified 11/16/13
            % generate array of randomized hold times first,
            % then draw from them as "stim" is incremented
            % Added 11/23/13 Individualized Random Hold Times
            % Q4 and Q6: 1-6s
            % All others: 1:8s
            % 141009 ALL CHINS ON 1-6s
            ChinID = get_id(handles);
            %if strcmp(ChinID,'Q201') || strcmp(ChinID,'Q206') || strcmp(ChinID,'Q213')
            %randmax = 4;
            % AM edited to 8 max 092915
            %else
            %             randmax= 8;
            
            %end
            nplayfromfile = max(handles.nplist); % get "dummy" from file
            if nplayfromfile==999 || nplayfromfile==998 || nplayfromfile==997 ...
                    || nplayfromfile==996 || nplayfromfile==995 || nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==891 || nplayfromfile==890 % if randomizing hold times
                numstim = length(handles.stmidx);
                n=numstim;  %ACM edit 5817  so round number with range of 2 to 9
                %ACM edit 2018 to individualize holdtimes per chin for
                %random- eventually all will be at 2-7 or 2-8?
                %                  if strcmp(ChinID,'Q342')%||strcmp(ChinID,'Q329')
                %                      R=[2:1:9];
                %                      z=rand(n,1)*range(R)+min(R);
                %                      narray=round(z');
                minHT=2;  % same for all chins
                if strcmp(ChinID,'Q331')
                    maxHT=9;
                    %                      R=[2:1:5];
                    %                      z=rand(n,1)*range(R)+min(R);
                    %                      narray=round(z');
                    %                  elseif strcmp(ChinID,'Q330')
                    %                      R=[2:1:9];
                    %                      z=rand(n,1)*range(R)+min(R);
                    %                      narray=round(z');
                    %                  elseif strcmp(ChinID,'Q333')
                    %                      R=[2:1:9];
                    %                      z=rand(n,1)*range(R)+min(R);
                    %                      narray=round(z');
                    %                  elseif strcmp(ChinID,'Q334')
                    %                      R=[2:1:9];
                    %                      z=rand(n,1)*range(R)+min(R);
                    %                      narray=round(z');
                    %                  elseif strcmp(ChinID,'Q337')
                    %                      R=[2:1:9];
                    %                      z=rand(n,1)*range(R)+min(R);
                    %                      narray=round(z');
                else
                    maxHT=9;
                    %                     R=[2:1:9];
                end
                R=[(minHT-0.5+eps):1:(maxHT+0.5-eps)];
                z=rand(n,1)*range(R)+min(R);
                narray=round(z');   %% 9/7/18: MH & AM: reset this to get equal trials for 2 and 9 (max), based on rounding (was giving half for 2 and 9 before).
            end
            %%% AEH modified 12/3/13
            % generate array of attenuation values for
            % pure tone audio by method of constant stimuli
            %% AEH modified 1/17/14
            % Tone in Quiet Levels: 0-70 5 dB steps
            % Tone in Noise Levels: 20-70 5 dB steps
            %% AEH modified 1/22/13
            % Add 8 more trials of 70 dB tone (0 dB atten)
            % to calculate d' and bias based on 70 dB and catch trials
            if nplayfromfile==998 || nplayfromfile==996 % if presenting level-varying stimuli
                attenarrayQuiet = [];
                % AEH added 140630 for new TIQ functions
                for attencount = 1:3 % 6 reps for NEW Tone in Quiet
                    attens = [0:5:80]; % add more 70 dB SPL (0 dB atten)
                    temparray = [attens;randperm(17)];
                    temparray = temparray';
                    sortedarray = sortrows(temparray,2);
                    attenarrayQuiet = [attenarrayQuiet;sortedarray(:,1)];
                end
                % AEH old:
                %                 for attencount = 1:3 % 3 reps for Tone in Quiet
                %                     attens = [0:5:70,0,0,0]; % add more 70 dB SPL (0 dB atten)
                %                     temparray = [attens;randperm(15+3)];
                %                     temparray = temparray';
                %                     sortedarray = sortrows(temparray,2);
                %                     attenarrayQuiet = [attenarrayQuiet;sortedarray(:,1)];
                %                 end
                attens = []; temparray = []; sortedarray = [];
                %                 clearvars attens temparray sortedarray
                %% "clearvars" not available in this version of Matlab
                attenarrayNoise = [];
                for attencount = 1:3 % 3 reps for Tone in Noise
                    attens = [0:5:60];
                    temparray = [attens;randperm(13)];
                    temparray = temparray';
                    sortedarray = sortrows(temparray,2);
                    attenarrayNoise = [attenarrayNoise;sortedarray(:,1)];
                end
            end
            
            if nplayfromfile==994 || nplayfromfile==993 % vary wav files for SAM discrim (AEH 140926)
                attenarrayAMdB = [];
                for attencount = 1:3 % 3 reps for Tone in Noise
                    attens = [0:3:30]; % add more 70 dB SPL (0 dB atten)
                    temparray = [attens;randperm(11)];
                    temparray = temparray';
                    sortedarray = sortrows(temparray,2);
                    attenarrayAMdB = [attenarrayAMdB;sortedarray(:,1)];
                end
            end
            
            if nplayfromfile==893 % MH: new simple SAM discrim (MH 040620)
                sigINDtemp=0;
                for stim = 1:length(handles.stmlist)
                    if handles.stmlist(handles.stmidx(stim)).test
                        sigINDtemp=sigINDtemp+1;
                        strIND1=findstr(handles.stmlist(handles.stmidx(stim)).name2,'dBT_')+4;
                        strIND2=findstr(handles.stmlist(handles.stmidx(stim)).name2,'dBAM')-1;
                        attenarrayAMdB(sigINDtemp)=str2num(handles.stmlist(handles.stmidx(stim)).name2(strIND1:strIND2));
                    end
                end
            end
            
            
            %% %%%%%%%%%%%%%%%%%%%
            % TODO: THIS ALL REALLY NEEDS setup more generally, with standard filenames with depvar,param1,param1 notation
            % setup better file naming convention.
            %% %%%%%%%%%%%%%%%%%%%
            if nplayfromfile==892 || nplayfromfile==891 % MH: new simple SAM discrim IN (MH 040720)
                sigINDtemp=0;
                for stim = 1:length(handles.stmlist)
                    strIND1_SNR=findstr(handles.stmlist(handles.stmidx(stim)).name2,'NN_')+3;
                    strIND2_SNR=findstr(handles.stmlist(handles.stmidx(stim)).name2,'dBSNR')-1;
                    SNRtext=handles.stmlist(handles.stmidx(stim)).name2(strIND1_SNR:strIND2_SNR);
                    if strcmp(SNRtext(1),'n')  % convert n back to negative
                        SNRtext(1)='-';
                    end
                    allSNRarray(stim)=str2num(SNRtext); % This is needed to save SNR for both catch and signal trials (since SNR varies across catch trials)
                    if handles.stmlist(handles.stmidx(stim)).test
                        if sigINDtemp==0 % only need to do these once
                            strIND1_fmod=findstr(handles.stmlist(handles.stmidx(stim)).name2,'kHz')+3;
                            strIND2_fmod=findstr(handles.stmlist(handles.stmidx(stim)).name2,'hzAM')-1;
                            AM_modfreq_Hz = str2num(handles.stmlist(handles.stmidx(stim)).name2(strIND1_fmod:strIND2_fmod));  % save scalar for this condition
                            
                            strIND1_moddepth=findstr(handles.stmlist(handles.stmidx(stim)).name2,'dBT_')+4;
                            strIND2_moddepth=findstr(handles.stmlist(handles.stmidx(stim)).name2,'dBAM')-1;
                            AM_moddepth_dB = str2num(handles.stmlist(handles.stmidx(stim)).name2(strIND1_moddepth:strIND2_moddepth));  % save scalar for this condition
                        end
                        sigINDtemp=sigINDtemp+1;
                        attenarraySNRdB(sigINDtemp)=str2num(SNRtext);
                    end
                end
            end
            
            
            if nplayfromfile==890 % MH: new simple CMR with no params except CMR setup# and CMR condition: REF/CORR/UCORR
                sigINDtemp=0;
                for stim = 1:length(handles.stmlist)
                    if handles.stmlist(handles.stmidx(stim)).test
                        sigINDtemp=sigINDtemp+1;
                        underscoreINDs=findstr(handles.stmlist(handles.stmidx(stim)).name2,'_');
                        % CMR stim Number
                        strIND1a=1;
                        strIND2a=underscoreINDs(1)-1;
                        % CMR condition : REF/CORR/UCORR
                        strIND1b=underscoreINDs(1)+1;
                        strIND2b=underscoreINDs(2)-1;
                        CMRstimPARAMS.CMRsetupNum{sigINDtemp}=handles.stmlist(handles.stmidx(stim)).name2(strIND1a:strIND2a);
                        CMRstimPARAMS.CMRcondition{sigINDtemp}=handles.stmlist(handles.stmidx(stim)).name2(strIND1b:strIND2b);
                        % CMR1 did not have No and T values in filename, so
                        % have to hard code that
                        if ~strcmp(CMRstimPARAMS.CMRsetupNum{sigINDtemp},'CMR1')
                            % No Level
                            strIND1_No=underscoreINDs(2)+3;
                            strIND2_No=underscoreINDs(3)-1;
                            % T Level
                            strIND1_T=underscoreINDs(3)+2;
                            strIND2_T=underscoreINDs(4)-1;
                            % Edited June 28 - to explicitly save T and No
                            % levels (M. Heinz)
                            CMRstimPARAMS.No_dBSPL(sigINDtemp)=str2num(handles.stmlist(handles.stmidx(stim)).name2(strIND1_No:strIND2_No));
                            CMRstimPARAMS.T_dBSPL(sigINDtemp)=str2num(handles.stmlist(handles.stmidx(stim)).name2(strIND1_T:strIND2_T));
                        else
                            CMRstimPARAMS.No_dBSPL(sigINDtemp)=30;
                            CMRstimPARAMS.T_dBSPL(sigINDtemp)=70;
                        end
                        
                    end
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            stim = 1;
            stimcount = 1; % for counting SPLs in level-varying paradigms
            while stim <= length(handles.stmidx) && magtraincount < 111
                if ~running(handles)
                    break;
                end
                drawnow
                if isempty(npidx)
                    npidx = randperm(length(handles.nplist));
                end
                
                if ~handles.DEBUG_emulate
                    handles.RP_bot.SetTagVal('ISI', handles.stmlist(handles.stmidx(stim)).isi);
                end
                
                %                 if length(handles.nplist) > 1 && handles.stmlist(handles.stmidx(stim)).test
                % test stimuli always have an NP of 5
                %                     if max(handles.nplist) > 5
                %                         nplay = 5;
                %                     else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%% AEH modified 11/16/13 and 1/4/14
                %%%% Randomize hold time from 1-8s
                %                         nplayfromfile = max(handles.nplist); % get "dummy" from file
                %                         disp(num2str(nplayfromfile))
                if nplayfromfile==999 || nplayfromfile==998 % FLAG randomize hold time
                    %                             ncount = 1;
                    %                             narray(1) = nplayfromfile; % get "dummy" from file
                    %                             while 1 % (narray(ncount) > 0) && (narray(ncount) < 9)
                    %                                 ncount = ncount + 1;
                    %                                 narray(ncount) = round(9*rand);
                    %                                 % disp(['This trial is: ',num2str(narray(ncount)),'s']);
                    %                                 if (narray(ncount) > 0) && (narray(ncount) < 9)
                    %                                     % disp('break occured')
                    %                                     break;
                    %                                 end
                    %                             end
                    nplay = narray(stim); % draw from randomized list
                    %  MH_AM:9/10/2018 fix dumWav.wav                     nplay = 2*nplay; % x2 since using 500ms stimuli
                    % determine if "signal" or "catch" trial
                    if handles.stmlist(handles.stmidx(stim)).test
                        testtype = 'Signal';
                    else
                        testtype = 'Catch';
                    end
                    %                             disp(['This trial is: ',num2str(nplay/2),'s, ',testtype,' Trial, ',num2str(atten2),' dB atten']);
                elseif nplayfromfile==997 || nplayfromfile==996 || nplayfromfile==995 || nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==891 || nplayfromfile==890 % TINtraining, don't double nplay
                    nplay = narray(stim); % draw from randomized list
                    %                             nplay = 2*nplay; % x2 since using 500ms stimuli
                    % determine if "signal" or "catch" trial
                    if handles.stmlist(handles.stmidx(stim)).test
                        testtype = 'Signal';
                    else
                        testtype = 'Catch';
                    end
                else % don't randomize hold time
                    nplay = max(handles.nplist);
                    nplayfromfile = nplay; % needed below in np results: setfield, getfield
                    if handles.stmlist(handles.stmidx(stim)).test
                        testtype = 'Signal';
                    else
                        testtype = 'Catch';
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                     end
                %                 else
                %                     nplay = handles.nplist(npidx(1)); % AEH will always happen during shaping (.same)
                %                 end
                if ~handles.DEBUG_emulate
                    handles.RP_bot.SetTagVal('NP', -nplay);
                end
                % AEH 130905 commented out--not sure what purpose this serves
                %                 if targets > 2 && handles.stmlist(handles.stmidx(stim)).same
                % nb = 2;
                %                 else
                nb = targets; % AEH
                %                     nb = targets-(targets-1); %disp(nb); % AEH quick n dirty fix 130909
                %                 end
                if ~handles.DEBUG_emulate
                    handles.RP_bot.SetTagVal('NB', nb);
                end
                
                atten1 = get_atten1(handles);
                atten2 = get_atten2(handles);
                if get_rove(handles)
                    atten1 = atten1 + 6*rand - 3;
                    atten2 = atten2 + 6*rand - 3;
                end
                % AEH modified 12/3/13
                % vary attenuation levels for pure tone audio
                % by method of constant stimuli
                % (attenuation levels are randomized above)
                % OR
                % fully attenuate "dummywav" click file
                % if it is a Catch (.same) trial
                % by default, this only applies to tests with Catch trials
                % AEH modified 1/2/14 added cases for Tone-in-Noise training
                if handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==998 % PTA (Catch Trial)
                    atten1 = 120;
                    atten2 = 120;
                elseif handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==999 % Shape/Rand/CT
                    atten1 = 120;
                    atten2 = 120;
                elseif handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==997 % TINTrain (Catch Trial)
                    atten1 = 10; % do not attenuate standard stimulus (noise bursts)
                    atten2 = 10; % do not attenuate signal (TIN)
                elseif handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==996 % TINAdj (Catch Trial)
                    %                     atten1 = 15; % hard-code this value instead (70-15 = 55)
                    %                     atten1 = atten1; % take atten1 from GUI (70-atten1 = noise dB) % 3/4/14
                    %                     atten2 = atten1;
                    % AEH 140915 hard-code noise level until we decide on level
                    atten1 = 25; % was 35
                    atten2 = atten1;
                elseif handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==995 % FreqTrain (Catch Trial)
                    atten1 = 20;
                    atten2 = 20;
                elseif handles.stmlist(handles.stmidx(stim)).same && (nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==890) % SAM (Catch Trial)
                    atten1 = 10;
                    atten2 = 10;
                elseif handles.stmlist(handles.stmidx(stim)).same && nplayfromfile==891 % SAMIN (Catch Trial - 65 dB SPL)
                    atten1 = 15;
                    atten2 = 15;
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==998 % PTA (Signal Trial)
                    atten1 = 120;
                    atten2 = attenarrayQuiet(stimcount);
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==999 % Shape/Rand/CT
                    atten1 = 120;
                    %                     atten2 = 0;
                    atten2 = 10;    %11-02-2015 edited MKW for SAM-NN to bring OAL down to 67dBOAL
                    %since stim switched from 4kHzSAM20HzT.wav to 4kHz80dBT_0dBAM_NN.wav
                    %to add NN to probe stimulus during RC Sam training next step creep
                    %standard Tone-in NN up in level
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==997 % TINTrain (Signal Trial)
                    atten1 = 10; % do not attenuate standard stimulus (noise bursts)
                    atten2 = 10; % do not attenuate signal (TIN)
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==996 % TINAdj (Signal Trial)
                    %                     atten1 = 15; % hard code this value instead (70-15 = 55)
                    %                     atten1 = atten1; % take atten1 from GUI (70-atten1 = noise dB) % 3/4/14
                    %                     atten2 = atten2; % tone level is fixed
                    % AEH 140915 hard-code noise level until we decide on level
                    atten1 = 25; % was 35
                    atten2 = attenarrayNoise(stimcount); % tone level varies
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==995 % FreqTrain (Signal Trial)
                    atten1 = 20;
                    atten2 = 20;
                elseif handles.stmlist(handles.stmidx(stim)).test && (nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==890) % SAM (Signal Trial)
                    atten1 = 10;
                    atten2 = 10;
                elseif handles.stmlist(handles.stmidx(stim)).test && nplayfromfile==891 % SAMIN (Signal Trial - 65 dB SPL)
                    atten1 = 15;
                    atten2 = 15;
                end
                a1 = atten1;
                a2 = atten2;
                thisSPL = 80-atten2; % for display purposes only
                
                    if DEBUG_trialDisplay
                        
                        % AEH moved here after "atten2" is set, while in "dB"
                        if nplayfromfile==999 || nplayfromfile==998 % Random or PTA
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);  %MH_AM:9/10/2018 fix dumWav.wav
                            else
                                disp([testtype,' trial, ',num2str(thisSPL),' dB SPL,',' ',num2str(nplay),'s hold time',]);  %MH_AM:9/10/2018 fix dumWav.wav
                            end
                        elseif nplayfromfile==997 || nplayfromfile==996
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);
                            else
                                disp([testtype,' trial, Noise at ',num2str(atten1),' dB atten, Signal at ',num2str(thisSPL),' dB SPL, ',num2str(nplay),'s hold time',]);
                            end
                        elseif nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);
                            else
                                disp([testtype,' trial, Mod. Depth ',num2str(attenarrayAMdB(stimcount)),' dB, Signal at ',num2str(thisSPL),' dB SPL, ',num2str(nplay),'s hold time',]);
                            end
                        elseif nplayfromfile==892 || nplayfromfile==891
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);
                            else
                                disp([testtype,' trial, SNR ',num2str(attenarraySNRdB(stimcount)),' dB, Signal at ',num2str(thisSPL),' dB SPL, ',num2str(nplay),'s hold time',]);
                            end
                        elseif nplayfromfile==890
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);
                            else
                                fprintf('%s trial, %.fs hold time, Setup: %s, Condition: %s\n',testtype,nplay,CMRstimPARAMS.CMRsetupNum{stimcount},CMRstimPARAMS.CMRcondition{stimcount});
                            end
                        elseif nplayfromfile==995
                            if handles.stmlist(handles.stmidx(stim)).same
                                disp([testtype,' trial, ',num2str(nplay),'s hold time',]);
                            else
                                disp([testtype,' trial, Standard at ',num2str(atten1),' dB atten, Test at ',num2str(atten2),' dB atten, ',num2str(nplay),'s hold time',]);
                            end
                        end
                    end
                atten1 = 10^(-atten1/20);
                atten2 = 10^(-atten2/20);
                
                %                if handles.stmlist(handles.stmidx(stim)).same
                %                    atten2 = atten1;
                %                end
                
                % AEH added 1/13/14
                % allow user to control noise and tone levels independently
                % and keep "old" way of attenuating .wav files for previous templates
                if nplayfromfile == 996 % TINadjust
                    % Noise only (during hold time)
                    if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name1, 'StimA', atten1)
                        set(hObject, 'String', '')
                        break
                    end
                    if strcmp(testtype,'Catch')
                        % Noise only (during response window)
                        if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name2, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    elseif strcmp(testtype,'Signal')
                        % Tone in noise (during response window)
                        fn1 = handles.stmlist(handles.stmidx(stim)).name1; % same noise token as hold time stimulus
                        fn2 = handles.stmlist(handles.stmidx(stim)).name2; % tone to be added to noise token
                        if ~declare_2sound_files(handles,'StimB',fn1,fn2,atten1,atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    end
                    % AEH added 140926
                    % allows randomization of SAM modulation depth by picking
                    % appropriate WAV file (instead of randomizing wav file list)
                elseif nplayfromfile == 994 % SAM
                    % During hold time
                    if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name1, 'StimA', atten1)
                        set(hObject, 'String', '')
                        break
                    end
                    % Signal/Catch
                    if strcmp(testtype,'Catch')
                        if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name2, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    elseif strcmp(testtype,'Signal')
                        % assign wav file name
                        AMfile = [handles.stmlist(handles.stmidx(stim)).name2,...
                            '_',num2str(attenarrayAMdB(stimcount)),'dBAM'];
                        if ~declare_sound_file(handles, AMfile, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    end
                elseif nplayfromfile == 993 % SAM WITH NOTCHED NOISE
                    % During hold time
                    % assign wav file name
                    AMfile = [handles.stmlist(handles.stmidx(stim)).name1,...
                        '_',num2str(999),'dBAM_NN'];
                    if ~declare_sound_file(handles, AMfile, 'StimA', atten1)
                        set(hObject, 'String', '')
                        break
                    end
                    % Signal/Catch
                    % assign wav file name
                    if strcmp(testtype,'Catch')
                        AMfile = [handles.stmlist(handles.stmidx(stim)).name2,...
                            '_',num2str(999),'dBAM_NN'];
                        if ~declare_sound_file(handles, AMfile, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    elseif strcmp(testtype,'Signal')
                        % assign wav file name
                        AMfile = [handles.stmlist(handles.stmidx(stim)).name2,...
                            '_',num2str(attenarrayAMdB(stimcount)),'dBAM_NN'];
                        if ~declare_sound_file(handles, AMfile, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    end
                else  % 893, 892 , 891, 890 MH: 040620 new simple********
                    if ~handles.DEBUG_emulate
                        if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name1, 'StimA', atten1)
                            set(hObject, 'String', '')
                            break
                        end
                        if ~declare_sound_file(handles, handles.stmlist(handles.stmidx(stim)).name2, 'StimB', atten2)
                            set(hObject, 'String', '')
                            break
                        end
                    else  % Human version
                        standard=declare_sound_file_Human(handles, handles.stmlist(handles.stmidx(stim)).name1, 'StimA', atten1); % Standard
                        signal=declare_sound_file_Human(handles, handles.stmlist(handles.stmidx(stim)).name2, 'StimB', atten2); % Signal
                    end
                end
                standard = standard';
                signal = signal';
                
                %% Create stimulus HERE (apply scaling to be same MAXamp)
                % nplay versions of standard, with silence in between ;
                % then (nb=4); SIG sil STD sil SIG sil STD sil 

               
                % Updated by: Fernando July 14
                % Standard only before response window --> # of standard
                % stimuli based on nplay
                standard_preresponse = [];
                
                for i = 1:nplay
                    %standard_preresponse(i,:) = [standard zeros(size(standard))];
                    standard_preresponse = horzcat(standard_preresponse,[standard zeros(size(standard))]);
                end
                % Stimuli (signal and standard) for response window --> #
                % based on nb
                stimuli_response = [];
                
                for i = 1:nb/2
                    %stimuli_response(i,:) = [signal zeros(size(standard)) standard zeros(size(standard))];
                    stimuli_response = horzcat(stimuli_response,[signal zeros(size(standard)) standard zeros(size(standard))]);
                end
                % Normalize stimuli based on max amplitude
                maxAmp = 0.08; % find max of signal and standard amp
                standard_preresponse = standard_preresponse/maxAmp;
                stimuli_response = stimuli_response/maxAmp;
     %%
                % [standard zeros(size(standard) standard
                % zeros(size(standard) ... standard zeros(size(standard) ||
                % signal zeros(size(standard) standard zeros(size(standard)
                % signal zeros(size(standard) standard zeros(size(standard) ];
                
                %stimulus = [standard zeros(size(standard)) signal zeros(size(standard))]/.08; %Need to find the max amplitude for standard and signal to normalize, instead of 0.8
                stimulus = horzcat(standard_preresponse,stimuli_response);
                %sound(stimulus,handles.fs_TDT)                

                
                while toc < t   % WHY NEEDED?
                    if ~running(handles)
                        break
                    end
                end
                if ~running(handles)  % Check for ABORT
                    break
                end
                startTime = datestr(now,13);
                wait_for_bar_press(handles,nplayfromfile);    %%%% press Enter or SPace to START TRIAL 
                input('Press Enter to Start trial')
                
                
                %% Play stimuli - HUMAN 
                % Updated by: Fernando July 14
%                 for i = 1:nplay
%                     %sound(standard_preresponse(i,:),handles.fs_TDT);
%                     snd = audioplayer(standard_preresponse(i,:),handles.fs_TDT);
%                     play(snd);
%                 end
%                 for i = 1:nb                   
%                     sound(stimuli_response(i,:),handles.fs_TDT);
% %                     snd = audioplayer(stimuli_response(i,:),handles.fs_TDT);
% %                     play(snd);
%                 end

                 %mod by: Andrew July 15
                 snd = audioplayer(stimulus,handles.fs_TDT);
                 play(snd);
                 tic
  %%              
                if ~running(handles)
                    break
                end
                
                %% Nov 15 2019 - when breakpoint here, all works.  OW/ often getting 500ms rt even when hold
                % maybe new PC too fast?  Add in 1 sec pause here.
                % Tried 1, .5, .1 - ALL WORKED.  yes just too fast a PC
                pause(.1);
                play_pair(hObject, eventdata, handles);  % Replace with play_pair_Human
                

                %% rt = play_pair_HUMAN structure
                % Press Enter to start trial
                % tic
                % sound(stimulus)
                % wait for space bar press
                % toc
                % shut off sound (see Rose's code ADC = audioplayer??)
                % rt = toc - tic (in seconds?)
                % return rt to main run 
                
                
                
                %                buffer = handles.RP_bot.ReadTagVEX('Buffer', 0, handles.RP_bot.GetTagVal('RT'), 'F32', 'F64', 1);
                %                keyboard
                
                if getbar(handles)
                    pause(handles.stmlist(handles.stmidx(stim)).isi/1000)
                else
                    set(handles.bar, 'BackGroundColor', get(gcbf, 'Color'))
                    drawnow
                end
                if ~handles.DEBUG_emulate
                    count = handles.RP_bot.GetTagVal('Count');
                else
                    count = 4;  % ??? what should this be?
                end
                
                %                 if handles.stmlist(handles.stmidx(stim)).same
                % %                     fprintf('#%d: same\n', stim)
                %                 else
                % %                     fprintf('#%d: different\n', stim)
                %                 end
                result = 'xx';
                AbCriterion = 0;
                
                % response time in miliseconds (duration of lever press)
                % replace second rt with the actual spacebar response time
                
                if ~handles.DEBUG_emulate
                    rt = round(handles.RP_bot.GetTagVal('RT')/fs_TDT*1000); %measuring response time using the TDT, won't always hit
                else
                     %rt = (nplay)*1000+150+500;  %always a hit**  %% REPLACE with tic/toc measure between (Enter and Space Bar Press)
                      input('Press Enter when you hear the signal')
                      stop(snd)
                     rt = round(toc*1000);
                end
                
                %% FROM HERE, all is the same  %% 
                 
                if nplayfromfile==800 % magazine training
                    reinforce(handles); % reward!
                    reward_count = reward_count+1;
                    animpresscount = animpresscount + 1;
                    magtraincount = magtraincount + 1;
                    fprintf(handles.fid,'%s\t Animal pressed lever (%d)\n', datestr(now,13), magtraincount); % AEH
                    output_log = get(handles.output_log, 'String');
                    set(handles.output_log, 'String', [output_log; {sprintf('%d Animal pressed lever', magtraincount)}]);
                else
                    % AEH big modification here:
                    % 1) Shaping and Random have only Test trials,
                    % so only score Ht, Ms, Ab
                    % 2) Random w/ Catch Trials scores Ht, Ms, Ab, CR, FA
                    % first, decide if test is 1) or 2), then score appropriately
                    % ScoreFlag is determined outside of the running loop (above)
                    if nplayfromfile < 20 % shaping
                        AbCriterion = (nplay)*1000+150;  %MH_AM:9/10/2018 fix dumWav.wav
                        HtCriterion = (nplay)*1000+4000;  % MH_AM:9/10/2018 fix dumWav.wav
                    elseif nplayfromfile==999 || nplayfromfile==998 % Random or PTA
                        AbCriterion = (nplay)*1000+150;  % MH_AM:9/10/2018 fix dumWav.wav
                        %should be 4000  *BUT - MATLAB is timing out after 3000ms. and rewarding MISSES***
                        % FIND WHERE THIS IS HAPPENING FOR RC - it's OK for
                        % TESTING  [FIXED: 9/10/2018: ***ALL TO DO WITH dumWav.wav being 1
                        % sample, rather than 500 msec of silence]
                        HtCriterion = (nplay)*1000+4000;   % MH_AM:9/10/2018 fix dumWav.wav
                    elseif nplayfromfile==997 || nplayfromfile==996 || nplayfromfile==995
                        AbCriterion = (nplay)*1000+150;
                        %                         HtCriterion = (nplay/2)*1000+2000+500; % AEH 140824
                        HtCriterion = (nplay)*1000+4000; % MH_AM:9/10/2018 fix dumWav.wav
                    elseif nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==891 || nplayfromfile==890
                        AbCriterion = (nplay)*1000+150;
                        HtCriterion = (nplay)*1000+4000; % AH/MH/MW 20170619 4s RT for SAM and SAMNN, need to make this variable based
                    end
                    %                     AbCriterion
                    %                     HtCriterion
                    if ScoreFlag % there are test trials and same trials
                        if (rt <= AbCriterion)
                            result = 'Ab';
                        elseif (rt <= HtCriterion) &&  (rt > AbCriterion) && handles.stmlist(handles.stmidx(stim)).same % AEH
                            result = 'FA';
                        elseif (rt <= HtCriterion) &&  (rt > AbCriterion) && handles.stmlist(handles.stmidx(stim)).test % AEH
                            result = 'Ht';
                        elseif (rt > HtCriterion) && handles.stmlist(handles.stmidx(stim)).same % AEH was nb +1
                            result = 'CR';
                        elseif (rt > HtCriterion) && handles.stmlist(handles.stmidx(stim)).test
                            result = 'Ms';
                        end
                    else % there are only test trials
                        if (rt <= AbCriterion)
                            result = 'Ab';
                        elseif (rt <= HtCriterion) &&  (rt > AbCriterion) && handles.stmlist(handles.stmidx(stim)).test % AEH
                            result = 'Ht';
                        elseif (rt > HtCriterion) && handles.stmlist(handles.stmidx(stim)).test
                            result = 'Ms';
                        end
                    end
                    
                    if strcmp(result, 'Ht') || strcmp(result, 'CR')... % returned CR on 141002
                            %|| (handles.stmlist(handles.stmidx(stim)).test && strcmp(result, 'Ms'))
                        reinforce_count = reinforce_count + 1;
                        if reinforce_count == VIR
                            reinforce_count = 0;
                        else
                            if nplayfromfile == 998 % TIQ Testing: reward Ht only! (not CR)
                                if strcmp(result, 'Ht')
                                    reinforce(handles);
                                    reward_count = reward_count+1;
                                end
                            else
                                % reward
                                % AEH 140418 edit
                                % for some chins, change # pellets for CR (1), Ht (1)
                                % to try to reduce overall FA
                                %                             if strcmp(ChinID,'Q3') || strcmp(ChinID,'Q4') || strcmp(ChinID,'Q8')
                                %                                 if strcmp(result, 'Ht')
                                %                                     reinforce(handles);
                                %                                     reward_count = reward_count+1;
                                %                                     % %                                 pause(1); % need to build in short delay
                                %                                     % %                                 reinforce(handles); % turned off 140514
                                %                                 elseif strcmp(result, 'CR')
                                %                                     %                                 reinforce(handles); % turned off 140514
                                %                                 end
                                %                             elseif strcmp(ChinID,'Q2') || strcmp(ChinID,'Q5') ... % AEH 140505 edit:
                                %                                     || strcmp(ChinID,'Q6') || strcmp(ChinID,'Q7') % other 4 chins receive 1 for Ht, 0 for CR
                                %                                 if strcmp(result, 'Ht')
                                %                                     reinforce(handles);
                                %                                     reward_count = reward_count+1;
                                %                                 elseif strcmp(result, 'CR')
                                %                                     % reinforce(handles);
                                %                                 end
                                %                                 % reinforce(handles); % one pellet each for CR or Ht
                                %                             else % AHRF chins
                                reinforce(handles);
                                reward_count = reward_count+1;
                                %                             end
                            end
                        end
                    end
                end
                
                while getbar(handles)  % MICRO LOOP needs pauses
                    pause(0.1);  % CHECK THIS IS OK??  MH/AM Jan 22 2020
                end
                set(handles.bar, 'BackGroundColor', get(gcbf, 'Color'))
                drawnow
                
                tic
                
                %                 rt = round(handles.RP_bot.GetTagVal('RT')/fs_TDT*1000);
                
                if nplayfromfile==999 || nplayfromfile==998 % Random or PTA
                    % This gets saved to file
                    fprintf(handles.fid, '%s Trial: %d; Stim: %d; %s %d %s %d %s %4d A1: %.1f A2: %.1f\n', ...
                        datestr(now,13), trial, stim, ...
                        handles.stmlist(handles.stmidx(stim)).name1, ...
                        handles.stmlist(handles.stmidx(stim)).isi, ...
                        handles.stmlist(handles.stmidx(stim)).name2, ...
                        nplay, result, rt, a1, a2); % AEH 130905 added 1 for display purposes  % MH_AM:9/10/2018 fix dumWav.wav
                elseif nplayfromfile==997 || nplayfromfile==996 || nplayfromfile==995 || nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==891 || nplayfromfile==890
                    fprintf(handles.fid, '%s Trial: %d; Stim: %d; %s %d %s %d %s %4d A1: %.1f A2: %.1f\n', ...
                        datestr(now,13), trial, stim, ...
                        handles.stmlist(handles.stmidx(stim)).name1, ...
                        handles.stmlist(handles.stmidx(stim)).isi, ...
                        handles.stmlist(handles.stmidx(stim)).name2, ...
                        nplay, result, rt, a1, a2); % AEH 130905 added 1 for display purposes
                elseif nplayfromfile~=800 % shaping, not magtrain
                    fprintf(handles.fid, '%s Trial: %d; Stim: %d; %s %d %s %d %s %4d A1: %.1f A2: %.1f\n', ...
                        datestr(now,13), trial, stim, ...
                        handles.stmlist(handles.stmidx(stim)).name1, ...
                        handles.stmlist(handles.stmidx(stim)).isi, ...
                        handles.stmlist(handles.stmidx(stim)).name2, ...
                        nplay, result, rt, a1, a2); % AEH 130905 added 1 for display purposes
                end
                
                if nplayfromfile~=800 % not magazine training
                    % This is displayed during test for experimenter to see
                    if handles.stmlist(handles.stmidx(stim)).same
                        thisSPLdisp = 0;
                    else
                        thisSPLdisp = thisSPL;
                    end
                    output_log = get(handles.output_log, 'String');
                    if nplayfromfile==999 || nplayfromfile==998 % Random or PTA
                        set(handles.output_log, 'String', ...
                            [output_log; {sprintf('%2d %2d %8s %3d %8s %1d %s %4d', trial, stim, ...
                            handles.stmlist(handles.stmidx(stim)).name1, ...
                            handles.stmlist(handles.stmidx(stim)).isi, ...
                            handles.stmlist(handles.stmidx(stim)).name2, ...
                            nplay, result, rt)}]); % AEH 130905 added 1 for display purposes % MH_AM:9/10/2018 fix dumWav.wav
                    elseif nplayfromfile==997 || nplayfromfile==996 || nplayfromfile==995 || nplayfromfile==994 || nplayfromfile==993 || nplayfromfile==893 || nplayfromfile==892 || nplayfromfile==891 || nplayfromfile==890
                        set(handles.output_log, 'String', ...
                            [output_log; {sprintf('%2d %2d %8s %3d %8s %1d %s %4d', trial, stim, ...
                            handles.stmlist(handles.stmidx(stim)).name1, ...
                            handles.stmlist(handles.stmidx(stim)).isi, ...
                            handles.stmlist(handles.stmidx(stim)).name2, ...
                            nplay, result, rt)}]); % AEH 130905 added 1 for display purposes
                    elseif nplayfromfile~=800 % shaping, not magtrain
                        set(handles.output_log, 'String', ...
                            [output_log; {sprintf('%2d %2d %8s %3d %8s %1d %s %4d', trial, stim, ...
                            handles.stmlist(handles.stmidx(stim)).name1, ...
                            handles.stmlist(handles.stmidx(stim)).isi, ...
                            handles.stmlist(handles.stmidx(stim)).name2, ...
                            nplay, result, rt)}]); % AEH 130905 added 1 for display purposes
                    end
                    
                    %                 if ~handles.stmlist(handles.stmidx(stim)).test
                    eval(sprintf('%ss = %ss + 1;', result, result));
                    if ~replace_trial
                        eval(sprintf('adj_%ss = adj_%ss + 1;', result, result));
                    end
                    %%% AEH modified below, 11/14/13 nplay --> nplayfromfile
                    np_results = setfield(np_results, {min(find(handles.nplist == nplayfromfile))}, result, {1}, ...
                        1 + getfield(np_results, {handles.nplist == nplayfromfile}, result, {1}));
                    %                 end
                end
                
                if handles.stmlist(handles.stmidx(stim)).test ...
                        | strcmp(result, 'Ht') | strcmp(result, 'CR') ...
                        | strcmp(result, 'Ab')
                    t = tbt;
                else
                    t = tto;
                end
                
                stimdata.trialType{stimdatacount} = testtype;
                stimdata.standard{stimdatacount} = handles.stmlist(handles.stmidx(stim)).name1;
                stimdata.signalOrCatch{stimdatacount} = handles.stmlist(handles.stmidx(stim)).name2;
                stimdata.ISI(stimdatacount) = handles.stmlist(handles.stmidx(stim)).isi;
                stimdata.holdTime(stimdatacount) = (AbCriterion-150)/1000;
                stimdata.atten1(stimdatacount) = a1;
                stimdata.atten2(stimdatacount) = a2;
                response.time{stimdatacount} = datestr(now,13);
                %                 response.stimNum % REVISIT
                response.holdTime(stimdatacount) = rt/1000;
                response.score{stimdatacount} = result;
                
                replace_trial = logical(0);
                
                %% AEH modified 12/3/13
                if ScoreFlag==0 % only test trials (shaping or random without catch trials)
                    if replace_errors & handles.stmlist(handles.stmidx(stim)).test ...
                            & (strcmp(result, 'FA') | strcmp(result, 'Ms'))
                        replace_trial = logical(1);
                        stimdatacount = stimdatacount + 1;
                    elseif ~strcmp(result, 'Ab')
                        npidx(1) = [];
                        stim = stim + 1;
                        stimdatacount = stimdatacount + 1;
                    elseif strcmp(result, 'Ab') % AEH added when Ab is first MT resp
                        stimdatacount = stimdatacount + 1;
                    end
                elseif ScoreFlag==1 % test and same trials (with catch trials)
                    if strcmp(result, 'Ab')
                        replace_trial = logical(1);
                        stimdatacount = stimdatacount + 1;
                    elseif ~strcmp(result, 'Ab')
                        if handles.stmlist(handles.stmidx(stim)).test % Signal trial
                            stimcount = stimcount + 1;
                            stimdatacount = stimdatacount + 1;
                        elseif handles.stmlist(handles.stmidx(stim)).same % Catch trial
                            stimdatacount = stimdatacount + 1;
                        end
                        npidx(1) = [];
                        stim = stim + 1;
                    end
                end
                
            end % end of while stim<=length stims
        end
        
        % AEH modified 140505 moved this section out of running loop:
        %         if running(handles)
        %             fprintf(handles.fid, '\n------------------------------------------------\nExperiment Parameters\n\n');
        %             fprintf(handles.fid, 'ID: %s\n', get_id(handles));
        %             fprintf(handles.fid, 'Weight (g): %d\n', get_weight(handles));
        %             fprintf(handles.fid, 'Run name (NP): %s\n', get_np(handles));
        %             fprintf(handles.fid, 'Replications: %d\n', get_reps(handles));
        %             fprintf(handles.fid, 'Rove amplitudes? %d\n', get_rove(handles));
        %             fprintf(handles.fid, 'Time Between Trials (ms): %d\n', get_tbt(handles));
        %             fprintf(handles.fid, 'Buzzer duration (ms): %d\n', get_buz(handles));
        %             fprintf(handles.fid, 'Total Time Out (ms): %d\n', get_tto(handles));
        %             fprintf(handles.fid, 'Replace Errors? %d\n', get_replace(handles));
        %             fprintf(handles.fid, 'Attenuation 1: %d dB\n', get_atten1(handles));
        %             fprintf(handles.fid, 'Attenuation 2: %d dB\n', get_atten2(handles));
        %             fprintf(handles.fid, 'Percent of Responses Reinforced: %d\n', get_reinforce(handles));
        %             fprintf(handles.fid, '# Target Repitition: %s\n\n', get_target_reps(handles));
        %             fprintf(handles.fid, '\n------------------------------------------------\nSummary\n\n');
        %             fprintf(handles.fid, 'Number of Trials : %5d\n', Hts + Mss + FAs + CRs + Abs);
        %             fprintf(handles.fid, 'Valid Trials     : %5d\n', Hts + Mss + FAs + CRs);
        %             fprintf(handles.fid, 'Hits   : %5d     Adj Hits   : %5d\n', Hts, adj_Hts);
        %             fprintf(handles.fid, 'Misses : %5d     Adj Misses : %5d\n', Mss, adj_Mss);
        %             fprintf(handles.fid, 'CRs    : %5d     Adj CRs    : %5d\n', CRs, adj_CRs);
        %             fprintf(handles.fid, 'FAs    : %5d     Adj FAs    : %5d\n', FAs, adj_FAs);
        %             fprintf(handles.fid, 'Aborts : %5d\n\n', Abs);
        %             fprintf(handles.fid, '%% Corr : %5.2f     Adj % Corr : %5.2f\n', ...
        %                 (Hts + CRs)/(Hts + CRs + FAs + Mss)*100, ...
        %                 (adj_Hts + adj_CRs)/(adj_Hts + adj_CRs + adj_FAs + adj_Mss)*100);
        %             fprintf(handles.fid, 'd''     : %5.2f     Adj d''     : %5.2f\n', dprime(Hts, Mss, CRs, FAs), ...
        %                 dprime(adj_Hts, adj_Mss, adj_CRs, adj_FAs));
        %             fprintf(handles.fid, '------------------------------------------------\n');
        %             fprintf(handles.fid, 'NP        Hits      Misses    CorRej    FlsAlrm\n');
        %             for i = 1:length(handles.nplist)
        %                 fprintf(handles.fid, '%2d        %3d       %3d       %3d       %3d\n', handles.nplist(i), ...
        %                     np_results(i).Ht, np_results(i).Ms, np_results(i).CR, np_results(i).FA);
        %             end
        %             fprintf(handles.fid, '------------------------------------------------\n');
        %         end
    end
else
    if strcmp(questdlg('Are you sure you want to stop the running program?', ...
            'Quiting experiment', 'No'), ...
            'Yes')
        set(hObject, 'String', 'Run', 'ForeGroundColor', 'k')
        if ~handles.DEBUG_emulate
            handles.RP_bot.SetTagVal('Lamp', logical(0));
        end
        uiupdate(hObject, eventdata, handles);
    end
    return
end

if nplayfromfile ~=800 % not magazine training
    % AEH modified 140505
    % moved summary table to end so that it still gets added to file
    % even in case when chin doesn't finish all trials (experimenter aborts program)
    % CHANGED: % Correct reflects performance out of total number of trials
    % NOT performance out of number of trials completed
    fprintf(handles.fid, '\n------------------------------------------------\nExperiment Parameters\n\n');
    fprintf(handles.fid, 'ID: %s\n', get_id(handles));
    fprintf(handles.fid, 'Weight (g): %d\n', get_weight(handles));
    fprintf(handles.fid, 'Run name (NP): %s\n', get_np(handles));
    fprintf(handles.fid, 'Replications: %d\n', get_reps(handles));
    fprintf(handles.fid, 'Rove amplitudes? %d\n', get_rove(handles));
    fprintf(handles.fid, 'Time Between Trials (ms): %d\n', get_tbt(handles));
    fprintf(handles.fid, 'Buzzer duration (ms): %d\n', get_buz(handles));
    fprintf(handles.fid, 'Total Time Out (ms): %d\n', get_tto(handles));
    fprintf(handles.fid, 'Replace Errors? %d\n', get_replace(handles));
    fprintf(handles.fid, 'Attenuation 1: %d dB\n', get_atten1(handles));
    fprintf(handles.fid, 'Attenuation 2: %d dB\n', get_atten2(handles));
    fprintf(handles.fid, 'Percent of Responses Reinforced: %d\n', get_reinforce(handles));
    %     fprintf(handles.fid, '# Target Repitition: %s\n\n', get_target_reps(handles));
    fprintf(handles.fid, '\n------------------------------------------------\nSummary\n\n');
    fprintf(handles.fid, 'Number of Trials : %5d\n', Hts + Mss + FAs + CRs + Abs);
    fprintf(handles.fid, 'Valid Trials     : %5d\n', Hts + Mss + FAs + CRs);
    fprintf(handles.fid, 'Hits   : %5d     Adj Hits   : %5d\n', Hts, adj_Hts);
    fprintf(handles.fid, 'Misses : %5d     Adj Misses : %5d\n', Mss, adj_Mss);
    fprintf(handles.fid, 'CRs    : %5d     Adj CRs    : %5d\n', CRs, adj_CRs);
    fprintf(handles.fid, 'FAs    : %5d     Adj FAs    : %5d\n', FAs, adj_FAs);
    fprintf(handles.fid, 'Aborts : %5d\n\n', Abs);
    fprintf(handles.fid, '%% Corr : %5.2f     Adj % Corr : %5.2f\n', ...
        (Hts + CRs)/(Hts + CRs + FAs + Mss)*100, ...
        (adj_Hts + adj_CRs)/(adj_Hts + adj_CRs + adj_FAs + adj_Mss)*100);
    fprintf(handles.fid, 'd''     : %5.2f     Adj d''     : %5.2f\n', dprime(Hts, Mss, CRs, FAs), ...
        dprime(adj_Hts, adj_Mss, adj_CRs, adj_FAs));
    fprintf(handles.fid, '------------------------------------------------\n');
    fprintf(handles.fid, 'NP        Hits      Misses    CorRej    FlsAlrm\n');
    for i = 1:length(handles.nplist)
        fprintf(handles.fid, '%2d        %3d       %3d       %3d       %3d\n', handles.nplist(i), ...
            np_results(i).Ht, np_results(i).Ms, np_results(i).CR, np_results(i).FA);
    end
    fprintf(handles.fid, '------------------------------------------------\n');
    fprintf(handles.fid, ['Total pellets delivered: ',num2str(reward_count)]);
end

% AEH new data structure
test.date = datestr(now,26);
test.startTime = startTime;
test.endTime = datestr(now,13);
test.runName = get_np(handles);
% test.reinforcements
test.percReinforcements = get_reinforce(handles);
test.rove = get_rove(handles);
test.TBT = get_tbt(handles);
test.TTO = get_tto(handles);
chin.ID = get_id(handles);
chin.weight = get_weight(handles);
chin.FFWperc = get(handles.pct_free_feed, 'String'); %% REVISIT

% clear -except test chin stimdata response
fooname = get_output_file(handles);
fooname = fooname(1:end-4);
% M. Heinz Aug 7 2017 - had to remove handles and hObject in NEW matlab to
% avoid FIG showing up when *mat was loaded.
% save([fooname,'.mat'])
save([fooname,'.mat'],'-regexp','^(?!(hObject|handles)$).')
disp(['Total pellets delivered: ',num2str(reward_count)]);

fclose(handles.fid);
if ~handles.DEBUG_emulate
    handles.RP_bot.Halt;
    handles.RP_bot.ClearCOF;
end
clear_output_file(handles);
set(hObject, 'String', 'Run', 'ForeGroundColor', 'k')
set(handles.accept, 'String', 'Accept');
set([handles.bar handles.lamp], 'BackGroundColor', get(gcbf, 'Color'));
uiupdate(hObject, eventdata, handles)

function d = dprime(H, M, C, F)

if (M + H) > 0
    ProbMiss = M/(M + H);
else
    ProbMiss = 0;
end
if (F + C) > 0
    ProbFA  = F/(F + C);
else
    ProbFA = 0;
end
ZMiss = -sqrt(2)*erfcinv(2*ProbMiss);
ZFA = -sqrt(2)*erfcinv(2*ProbFA);
d = abs(ZFA + ZMiss);

function play_pair(hObject, eventdata, handles)

% Adding error-checking
rc_SoftTrg2=0;
while ~rc_SoftTrg2
    if ~handles.DEBUG_emulate
        rc_SoftTrg2=handles.RP_bot.SoftTrg(2)
    else
        rc_SoftTrg2=1;
    end
    if ~rc_SoftTrg2
        fprintf('rc_SoftTrg ERROR - retrying\n')
    end
end

set(handles.play, 'BackGroundColor', 'b')
drawnow

% wait for Trial to END (either bar release or TIME EXPIRES - sets Playing to zero in circuit)
% MH/AM Jan 22 2020
% Micro loop - causing problems
BarCheck_resolution_ms=100;
bcCOUNT=1;
temp_Playing = 1;
while temp_Playing
    if ~handles.DEBUG_emulate
        temp_Playing = handles.RP_bot.GetTagVal('Playing');
    else
        temp_Playing = 0; % end trial?
    end
    %     fprintf('Waiting for Trial to END (check each %.0f ms): %d\n   ***Playing = %d\n',BarCheck_resolution_ms,bcCOUNT,temp_Playing)
    pause(BarCheck_resolution_ms/1000)
    bcCOUNT=bcCOUNT+1;
end

set(handles.play, 'BackGroundColor', get(gcbf, 'Color'))
drawnow

function success = declare_sound_file(handles, filename, buffer, atten)

success = logical(0);

filename = fullfile('stim', filename);
try
    [stim fs] = audioread(strcat(filename,'.wav'));     % [stim fs] = wavread(filename);
catch
    err = lasterror;
    waitfor(errordlg(sprintf('Unable to open %s:\n%s', strcat(filename,'.wav'), err.message), ...
        'File error', 'modal'))
    return
end

stim = [zeros(10,1); 10*atten*stim; zeros(10,1)];

if fs ~= round(handles.fs_TDT)
    waitfor(errordlg(sprintf('Sampling rate of sound file (%d Hz) does not match that of device (%d Hz).', ...
        round(fs), round(handles.fs_TDT)), 'Sound File Error', 'modal'))
    return
end

% MH/AM Jan 22 2020: Fixing to try again if fail
test_bot.ZeroTag=0;
MAXtrys=10;
TRYnum=1;
while ~test_bot.ZeroTag
    %     buffer
    if ~handles.DEBUG_emulate
        test_bot.ZeroTag = handles.RP_bot.ZeroTag(buffer)
    else
        test_bot.ZeroTag = 1;
    end
    if ~test_bot.ZeroTag
        fprintf('FAILED TDT ZeroTag (Unable to clear buffer) (TRY #: %d), re-trying ...\n',TRYnum)
        if TRYnum==MAXtrys
            waitfor(errordlg('Unable to clear buffer', 'Device error', 'modal'))
            return
        else
            TRYnum=TRYnum+1;
            pause(1)
        end
    else
        %         disp(sprintf('ZeroTag SUCCESS (ABLE to clear buffer: %s) ',buffer))
    end
end

% if ~handles.RP_bot.ZeroTag(buffer)
%     waitfor(errordlg('Unable to clear buffer', 'Device error', 'modal'))
%     return
% end

if ~handles.DEBUG_emulate
    if ~handles.RP_bot.WriteTagVEX(buffer, 0, 'F32', stim)
        waitfor(errordlg('Unable to write sound file to device', 'Device error', 'modal'));
        return
    end
    if ~handles.RP_bot.SetTagVal([buffer 'Len'], length(stim)/fs*1000)
        waitfor(errordlg('Unable to set signal length', 'Device error', 'modal'));
        return
    end
end

success = logical(1);


%% ADDING new function for Human Emulate version
function stim = declare_sound_file_Human(handles, filename, buffer, atten)

filename = fullfile('stim', filename);
try
    [stim fs] = audioread(strcat(filename,'.wav'));     % [stim fs] = wavread(filename);
catch
    err = lasterror;
    waitfor(errordlg(sprintf('Unable to open %s:\n%s', strcat(filename,'.wav'), err.message), ...
        'File error', 'modal'))
    return
end

% stim = [zeros(10,1); 10*atten*stim; zeros(10,1)];
stim = [zeros(10,1); stim; zeros(10,1)];   % NO attenuation for now

if fs ~= round(handles.fs_TDT)
    waitfor(errordlg(sprintf('Sampling rate of sound file (%d Hz) does not match that of device (%d Hz).', ...
        round(fs), round(handles.fs_TDT)), 'Sound File Error', 'modal'))
    return
end



%% AEH added 1/12/14
% Play tone and noise waveforms simultaneously
% and set atten separately for noise vs tone
function success = declare_2sound_files(handles,buffer,filename1,filename2,atten1,atten2)
success = logical(0);
% File1
filename1 = fullfile('stim',filename1);
try
    [stim1 fs1] = audioread(strcat(filename1,'.wav'));   % [stim1 fs1] = wavread(filename1);
catch
    err = lasterror;
    waitfor(errordlg(sprintf('Unable to open %s:\n%s', strcat(filename1,'.wav'), err.message), ...
        'File error', 'modal'))
    return
end
% File 2
filename2 = fullfile('stim',filename2);
try
    [stim2 fs2] = audioread(strcat(filename2,'.wav'));   % [stim2 fs2] = wavread(filename2);
catch
    err = lasterror;
    waitfor(errordlg(sprintf('Unable to open %s:\n%s', strcat(filename2,'.wav'), err.message), ...
        'File error', 'modal'))
    return
end
stim = [zeros(10,1); 10*atten1*stim1+10*atten2*stim2; zeros(10,1)];
if fs1~=round(handles.fs_TDT) || fs2~=round(handles.fs_TDT)
    waitfor(errordlg(sprintf('Sampling rate of sound file (%d Hz) does not match that of device (%d Hz).', ...
        round(fs), round(handles.fs_TDT)), 'Sound File Error', 'modal'))
    return
end
if ~handles.DEBUG_emulate
    if ~handles.RP_bot.ZeroTag(buffer)
        waitfor(errordlg('Unable to clear buffer', 'Device error', 'modal'))
        return
    end
    if ~handles.RP_bot.WriteTagVEX(buffer, 0, 'F32', stim)
        waitfor(errordlg('Unable to write sound file to device', 'Device error', 'modal'));
        return
    end
end
if fs1~=fs2
    waitfor(errordlg('Stim file sampling rates do not match', 'Device error', 'modal'));
    return
end
if ~handles.DEBUG_emulate
    if ~handles.RP_bot.SetTagVal([buffer 'Len'], length(stim)/fs1*1000) % check above that fs1==fs2
        waitfor(errordlg('Unable to set signal length', 'Device error', 'modal'));
        return
    end
end
success = logical(1);


function reinforce(handles)

if ~handles.DEBUG_emulate
    handles.RP_bot.SoftTrg(1);
end

% if ~isempty(varargin)
%     nplayfromfile = varargin(1);
%     mancount = varargin(2);
%     magtraincount = varargin(3);
%     if nplayfromfile == 800 % magazine training
%         mancount = mancount + 1;
%         magtraincount = magtraincount + 1;
%         fprintf(handles.fid, '%s\t Manual reinforcement (%d)\n', datestr(now,13), magtraincount); % AEH
%         output_log = get(handles.output_log, 'String');
%         set(handles.output_log, 'String', [output_log; {sprintf('%d Manual reinforcement', magtraincount)}]);
%     end
% end


% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~accepted(handles)
    if isempty(get_id(handles))
        waitfor(errordlg('You must select a chinchilla ID.', 'Parameter error', 'modal'));
    elseif get_weight(handles) < 0
        waitfor(errordlg('You must enter current chinchilla weight.', 'Parameter error', 'modal'));
    elseif isempty(get_np(handles))
        waitfor(errordlg('You must indicate a run name (NP) file.', 'Parameter error', 'modal'));
    elseif get_reps(handles) == 0
        waitfor(errordlg('Number of replications must be at least 1.', 'Parameter error', 'modal'));
    elseif get_tbt(handles) < 0
        waitfor(errordlg('You must enter time between trials (TBT).', 'Parameter error', 'modal'));
    elseif get_buz(handles) < 0
        waitfor(errordlg('You must enter buzzer duration (BUZ).', 'Parameter error', 'modal'));
    elseif get_tto(handles) < 0
        waitfor(errordlg('You must enter total time out (TTO).', 'Parameter error', 'modal'));
    elseif isempty(get_output_file(handles))
        waitfor(errordlg('You must indicate output file name.', 'Parameter error', 'modal'));
    elseif  isnan(get_atten1(handles))
        waitfor(errordlg('You must give a valid first stimulus attenuation value.', 'Parameter error', 'modal'));
    elseif isnan(get_atten2(handles))
        waitfor(errordlg('You must give a valid second stimulus attenuation value.','Parameter error', 'modal'));
    elseif get_reinforce(handles) < 0
        waitfor(errordlg('You must indicate percent reinforcement', 'Parameter error', 'modal'));
    else
        np_file = [get_np(handles) '.np'];
        fid = fopen(np_file, 'rt');
        if fid == -1
            waitfor(errordlg(sprintf('Unable to find %s.', np_file), 'File error', 'modal'));
            return
        end
        [handles.nplist count] = fscanf(fid, '%d');
        fclose(fid);
        if count == 0
            waitfor(errordlg(sprintf('There are no NPs in %s.', np_file), 'NP error', 'modal'))
            return
        end
        stm_file = [get_np(handles), '.stm'];
        fid = fopen(stm_file, 'rt');
        if fid == -1
            waitfor(errordlg(sprintf('Unable to find %s.', stm_file), 'File error', 'modal'));
            return
        end
        %         if ~invoke(handles.RP_bot, ['Connect' get_device(handles)], get_interface(handles), ...
        %                 get_device_number(handles))
        % 12/13/19 - still not working
        if ~handles.DEBUG_emulate
            if ~handles.RP_bot.ConnectRP2(get_interface(handles),get_device_number(handles))
                waitfor(errordlg(sprintf('Unable to connect to device %s #%d on %s interface.', ...
                    get_device(handles), get_device_number(handles), get_interface(handles)), ...
                    'Connection problem', 'modal'))
                return
            end
        end
        if strcmp(get_device(handles), 'RM1')
            rco_file = 'chinch_rm1.rco'; %sprintf('%s.rco', get_device(handles));
        else
            rco_file = 'chinch.rco';
        end
        if ~exist(rco_file, 'file')
            waitfor(errordlg(sprintf('File %s does not exist.', rco_file), 'RCO error', 'modal'));
            return
        end
        if ~handles.DEBUG_emulate
            if ~handles.RP_bot.LoadCOF(rco_file)
                waitfor(errordlg(sprintf('Unable to load %s COF.', rco_file), 'Device error', 'modal'))
                return
            end
        end
        same = logical(1);
        test = logical(0);
        handles.stmlist = [];
        while ~feof(fid)
            line = fgetl(fid);
            if isequal(line, -1)
                break
            end
            line = deblank(line);
            %             disp(line)
            if strcmp(line, '*')
                same = logical(0);
                test = logical(1);
            elseif strcmp(line, '**')
                %                 test = logical(1);
            elseif strcmp(line, '***')
                break;
            else
                [name1 isi name2] = strread(line, '%s %d %s');
                [pathstr name ext] = fileparts(name1{1});
                if strcmpi(ext, '.sw') | strcmpi(ext, '.wav')
                    name1{1} = name;
                end
                [pathstr name ext] = fileparts(name2{1});
                if strcmpi(ext, '.sw') | strcmpi(ext, '.wav')
                    name2{1} = name;
                end
                handles.stmlist(end+1).name1 = name1{1};
                handles.stmlist(end).isi = isi;
                handles.stmlist(end).name2 = name2{1};
                handles.stmlist(end).same = same;
                handles.stmlist(end).test = test;
            end
        end
        fclose(fid);
        handles.fid = fopen(get_output_file(handles), 'wt');
        if handles.fid == -1
            errordlg(sprintf('Unable to write to %s.', get_output_file(handles)), ...
                'modal');
            return
        end
        guidata(hObject, handles);
        write_header(handles);
        set(hObject, 'String', 'Change');
        uiupdate(hObject, eventdata, handles);
    end
else
    set(hObject, 'String', 'Accept');
    fclose(handles.fid);
    uiupdate(hObject, eventdata, handles);
end

function a = accepted(handles)

a = strcmp(get(handles.accept, 'String'), 'Change');

function accepted_enable(hObject, handles, state)

if nargin < 3
    state = 'on';
end

if accepted(handles)
    set(hObject, 'Enable', 'off')
else
    set(hObject, 'Enable', state);
end

function running_enable(hObject, handles, state)

if nargin < 3
    state = 'on';
end

if running(handles)
    if strcmp(state, 'on')
        set(hObject, 'Enable', 'off')
    else
        set(hObject, 'Enable', 'on')
    end
else
    set(hObject, 'Enable', state);
end

function ID_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function np_update(hObject, eventdata, handles)

if accepted(handles) | isempty(get_id(handles))
    set(hObject, 'Enable', 'off');
elseif eventdata == handles.ID
    id = get_id(handles);
    fid = fopen('CHINCH.DAT', 'rt');
    line = '';
    while ~strcmp(line, id)
        line = sscanf(fgetl(fid), '%s');
    end
    fgetl(fid);
    nps = {};
    while ~strcmp(line, '*') & ~feof(fid)
        line = deblank(fgetl(fid));
        if line ~= -1 & ~strcmp(line, '*')
            [np count] = sscanf(line, '%s');
            if count ~= 0
                nps{end+1} = np;
            end
        end
    end
    fclose(fid);
    if length(nps) == 0
        errordlg('There are no NP files for this chinchilla', 'No NPs', 'modal')
        set(hObject, 'Enable', 'off', 'String', 'Select', 'Value', 1);
    elseif length(nps) == 1
        set(hObject, 'Enable', 'on', 'String', nps);
    else
        set(hObject, 'Enable', 'on', 'String', [{'Select'} nps], 'Value', 1);
    end
else
    set(hObject, 'Enable', 'on');
end

function rep_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function rove_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function tbt_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function buz_update(hObject, eventdata, handles)

%accepted_enable(hObject, handles);

function tto_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function replace_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function output_file_update(hObject, eventdata, handles)

if accepted(handles)
    set(hObject, 'Enable', 'off')
elseif isempty(get_id(handles))
    set(hObject, 'String', '', 'UserData', '', 'Enable', 'off');
elseif eventdata == handles.ID
    set(hObject, 'String', '', 'UserData', '', 'Enable', 'inactive');
else
    set(hObject, 'Enable', 'inactive');
end

function output_select_update(hObject, eventdata, handles)

if accepted(handles) | isempty(get_id(handles))
    set(hObject, 'Enable', 'off');
else
    set(hObject, 'Enable', 'on');
end

function atten1_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function atten2_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function reinforce_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function reps_update(hObject, eventdata, handles)

accepted_enable(hObject, handles);

function run_update(hObject, eventdata, handles)

if accepted(handles)
    set(hObject, 'Enable', 'on')
else
    set(hObject, 'Enable', 'off');
end

function bar_update(hObject, eventdata, handles)

set(hObject, 'ForeGroundColor', 'k')

function lamp_update(hObject, eventdata, handles)

set(hObject, 'ForeGroundColor', 'k');

function accept_update(hObject, eventdata, handles)

if get_device_number(handles) > 0
    running_enable(hObject, handles);
else
    set(hObject, 'Enable', 'off');
end

function interface_update(hObject, eventdata, handles)

running_enable(hObject, handles);

function exit_update(hObject, eventdata, handles)

running_enable(hObject, handles);

function write_header(handles)

fid = handles.fid;
fprintf(fid, 'Output from MATLAB Chinchilla Program\n');
fprintf(fid, 'Version 22; All tests for AM cohort 2 (AEH 20 May 2014)\n\n'); % AEH  %ACM edited 060717 ACM 082918
fprintf(fid, 'Date: %s\nTime: %s\n', ...
    get(handles.date, 'String'), get(handles.time, 'String'));
fprintf(fid, 'Chinchilla ID: %s\n', get_id(handles));
% fprintf(fid, '     Replacement of aborted trials ');
% if get_replace(handles)
%     fprintf(fid, 'enabled.\n');
% else
%     fprintf(fid, 'disabled.\n');
% end
fprintf(fid, 'Weight: %.0f\n%%FFW: %s\n\n', ...
    get_weight(handles), get(handles.pct_free_feed, 'String'));


% fprintf(fid, 'Weight: %.2f\n', get_weight(handles), 'String');
% fprintf(fid, 'FFW: %s\n\n', get(handles.pct_free_feed, 'String'));

% fprintf(fid, 'Run Name: %s.     %d stimulus pairs presented ', ...
%     get_np(handles), length(handles.stmlist));
% fprintf(fid, '%d times each for %d total trials.\n\n', get_reps(handles), ...
%     length(handles.stmlist)*get_reps(handles));
% fprintf(fid, 'Rove: ');
% if get_rove(handles)
%     fprintf(fid, 'y');
% else
%     fprintf(fid, 'n');
% end
% fprintf(fid, '     TBT: %.2f s     BUZ: %.2f s     TTO: %.2f s\n', ...
%     get_tbt(handles), get_buz(handles), get_tto(handles));
% fprintf(fid, 'Output file name (Name of this file): %s\n\n\n', ...
%     get_output_file(handles));

% MH/AM: Jan 10 2020
function barVALUE = getbar(handles)
% Occasional glitches (eg barTEMP = 589505344) from other chamber calling TDT, which we need to
% detect and if so, re-ask for bar status (which MUST be 0 or 1).
% **WORKS!!
barTEMP=-999;
while barTEMP~=0 & barTEMP~=1
    if barTEMP ~=-999, fprintf('GLITCH: barTEMP = %d\n',barTEMP);, end  % FLAG when a glicth occurs
    if ~handles.DEBUG_emulate
        barTEMP=handles.RP_bot.GetTagVal('Bar');
    else
        bTEMP = randperm(2)-1;
        barTEMP = bTEMP(1);
    end
    %     fprintf('bar = %d\n',barTEMP);
end
barVALUE=barTEMP;

function pressed = bar_pressed(handles)  % 0 or 1 returned

barVALUE=getbar(handles);  % Clean (no glitches) version of barVALUE
% Only do this after getting a non-jibberish value
if barVALUE
    set(handles.bar, 'BackGroundColor', 'b');
    pressed = logical(1);
else
    set(handles.bar, 'BackGroundColor', get(gcbf, 'Color'));
    pressed = logical(0);
end
drawnow

function wait_for_bar_press(handles,nplayfromfile)
% 1st make sure bar is not pressed, ow/ WAIT for release or ABORT
% 2nd WAIT for bar press or ABORT

switch_lamp(handles, logical(0));

% MH/AM - Jan 9 2020 - MicroLoop *** causes problems for other system
% connecting when this one is busy "checking" bar and aborts ALL THE TIME
% need pause to give some time to breathe, but need to keep bar check to
% every 10 ms to keep RT computation accurate enough for time window
% 150-4000 determination.
% ** IF EVER need really accurate RT, this will need revisted.
% So, for now we have a precision of <10-ms for bar press and <10-ms for
% bar release, so RT has precision of <20-ms!!  Need to keep in mind.
%
% What we want check bar every 10?? ms, check ABORT every 200 ms
%
%MH/AM Jan 9 2020 - need to slow this down to avoid checking a million times a second in the tiny loops used throughout
% USE these parameters throughout in ALL MicroLoops to manage timing with
% breathes to avoid other chamber conflicts, but in a way we know the
% resolutions we want.
BarCheck_resolution_ms=100;
AbortCheck_resolution_ms=200;

% wait for bar not to be pressed before waiting for press
bcCOUNT=0;
while bar_pressed(handles)
    bcCOUNT=bcCOUNT+1;
    %     fprintf('BarReleaseCheck %d\n',bcCOUNT)
    pause(BarCheck_resolution_ms/1000)
    % Only if AbortCheck resolution has passed, check for Abort
    if bcCOUNT>=(round(AbortCheck_resolution_ms/BarCheck_resolution_ms))
        %         disp('AbortCheck')
        if ~running(handles)  % Added pause(.1) inside running to slow downs  %MH/AM Jan 9 2020 - need to slow this down to avoid checking a million times a second in the tiny loops used throughout
            break
        end
        bcCOUNT=0;
    end
end

if nplayfromfile==800 % magazine training
    switch_lamp(handles, logical(0)); % AEH was 1
else
    switch_lamp(handles, logical(1));
end

% now that we know bar not pressed, wait for bar press
bcCOUNT=0;
while ~bar_pressed(handles)
    bcCOUNT=bcCOUNT+1;
    %     fprintf('BarPressCheck %d\n',bcCOUNT)
    pause(BarCheck_resolution_ms/1000)
    % Only if AbortCheck resolution has passed, check for Abort
    if bcCOUNT>=(round(AbortCheck_resolution_ms/BarCheck_resolution_ms))
        %         disp('AbortCheck')
        if ~running(handles)  % Added pause(.1) inside running to slow downs  %MH/AM Jan 9 2020 - need to slow this down to avoid checking a million times a second in the tiny loops used throughout
            break
        end
        bcCOUNT=0;
    end
end
switch_lamp(handles, logical(0));
% bar_pressed(handles); %delete this line

function switch_lamp(handles, on)

if ~handles.DEBUG_emulate
    handles.RP_bot.SetTagVal('Lamp', on);
end

if on
    set(handles.lamp, 'BackGroundColor', 'b')
else
    set(handles.lamp, 'BackGroundColor', get(gcbf, 'Color'))
end

function handles = shuffle(hObject, handles)

% randomize stimuli
test = cat(1,handles.stmlist.test);
test_stims = find(test);
nontest_stims = find(~test);
nnontest = length(nontest_stims);
% if there are more than 40 stimuli, make sure that test
% stimuli do not occur in the first 20 or last 20 trials.
% if nnontest > 40
%     idx = randperm(nnontest);
%     start = nontest_stims(idx(1:20));
%     finish = nontest_stims(idx(21:40));
%     nontest_stims(idx(1:40)) = [];
% else
start = [];
finish = [];
% end
stims = [nontest_stims(:); test_stims(:)];
% AEH note: called "middle" because of KK decision
% to exclude test trials from beginning/end of test
% We are keeping the var name, but all signal and
% catch trials are randomized together
middle = stims(randperm(length(stims)));
handles.stmidx = [start(:); middle(:); finish(:)];
guidata(hObject, handles);

function output_log_Callback(hObject, eventdata, handles)
% hObject    handle to output_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_log as text
%        str2double(get(hObject,'String')) returns contents of output_log as a double


% --- Executes during object creation, after setting all properties.
function output_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in manual_reinforce.
function manual_reinforce_Callback(hObject, eventdata, handles)
% hObject    handle to manual_reinforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global nplayfromfile
global mancount
global magtraincount

reinforce(handles);
reward_count = reward_count+1;
if nplayfromfile == 800 % magazine training
    mancount = mancount + 1;
    magtraincount = magtraincount + 1;
    fprintf(handles.fid, '%s\t Manual reinforcement (%d)\n', datestr(now,13), magtraincount); % AEH
    output_log = get(handles.output_log, 'String');
    set(handles.output_log, 'String', [output_log; {sprintf('%d Manual reinforcement', magtraincount)}]);
end




function manual_reinforce_update(hObject, eventdata, handles)

if running(handles)
    set(hObject, 'Enable', 'on')
else
    set(hObject, 'Enable', 'off')
end


% --- Executes on selection change in target_reps.
function target_reps_Callback(hObject, eventdata, handles)
% hObject    handle to target_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns target_reps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from target_reps

function target_reps_update(hObject, eventdata, handles)

accepted_enable(hObject, handles)

function nb = get_target_reps(handles)

nb = get(handles.target_reps, 'Value') - 1;

% --- Executes during object creation, after setting all properties.
function target_reps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


