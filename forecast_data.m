function [ ] = forecast_data( city_name, forecast_definition, varargin )
% Function to read data from HWK Kompakt WS-xx Modbus
% Example
% forecast_data('München','Niederschlag-Menge-Heute-Morgen-Dritter_Folgetag-Abend','23-Nov-2013-25-Nov-2013',1,6)
% forecast_data('München','Luftdruck--Heute-Morgen-Heute-Abend','23-Nov-2013-23-Nov-2013',1,6)
% forecast_data('München',cell_array,'23-Nov-2013-23-Nov-2013',1,6)
%
%   Function to get the forecast data provided by the weather station HWK
%   Kompakt. The arguments for this function are CITY NAME (available in
%   the CityList), specific FORECAST DATA and INTERVAL, OBSERVATION
%   INTERVAL (dd-mmm-yyyy), RESOLUTION and UPDATE INTERVAL (multiple of 6).
%
%   Calling the function you will be asked for a folder to save the data to.
%   After selecting the folder, you have to load the neccessary register data (weather_station_data.mat). 
%
%   FORECAST DATA and INTERVAL could be provided as a cell array avoiding
%   several function callings. Example for all data is given in the .mat
%   file all_requests_function.
% 
%   Available FORECAST DATA:
%       Luftdruck--                    (only **)
%       Markantes_Wetter-
%               Bodennebel
%               Gefrierender_Nebel
%               Bodenfrost
%               Boeen
%               Niederschlag
%               Hitze
%               Kaelte    
%       Niederschlag- 
%               Menge
%               Wahrscheinlichkeit
%       Signifikantes_Wetter--
%       Solarleistung-
%               Dauer              (only **)
%               Einstrahlung       (only **)
%       Wind-
%               Richtung
%               Staerke
%       Temperatur-
%               Min
%               Max
%               Mittlere_temp_prog (only ***)
%
%   Available FORECAST INTERVAL:
%       Heute (**)
%       Erster_Folgetag (**)
%       Zweiter_Folgetag 
%       Dritter_Folgetag 
%       Morgen
%       Vormittag
%       Nachmittag
%       Abend
%       0_00AM-11_00PM (1 hour step) (***)
%
%   UPDATE INTERVAL
%       Month abbreviation has to be in english format
%       Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Oct, Sep, Nov, Dec
%   
%   To end the function and to save all results, type delete(timerfind)


% filepath = uigetdir('','Please select folder to save forecast data');


if ~isempty(varargin)
    start_observation       = varargin{1};
    end_observation         = varargin{2};
    resolution              = varargin{3};
    update_interval         = varargin{4};
    if size(varargin,2) > 4
        filepath            = varargin{5};
    else
        filepath            = strcat(pwd,'Aufzeichnungen');
        [s,mess,messid]     = mkdir(filepath);
        fprintf(strcat(mess,'\n'));
    end
end

[reg_data_file_name, reg_data_path_name] = uigetfile('','Please first load neccessary register data');
reg_data = strcat(reg_data_path_name,reg_data_file_name);
load(reg_data);

assignin('base','register_data_hwk_kompakt',register_data_hwk_kompakt);
assignin('base','CityList',CityList);
assignin('base','CityList_Sorted',CityList_Sorted);

if evalin('base', ('exist(''serial_interface'')')) == 1
    evalin('base', ('delete(''serial_interface'')'));
    evalin('base', 'clear serial_interface');
    evalin('base', 'delete(instrfind)');
end

% Set device id

device_id                   = '03';

% Create and reset data container

weather_data            = cell(1,4);
assignin('base','weather_data',weather_data);
new_data                = cell(1,2);
assignin('base','new_data',new_data);

% If forecast_definition is not a cell array but a char, convert to cell
% array.

if ~iscell(forecast_definition)
    forecast_definition = {forecast_definition};
end

% Check for available COM Ports

av_com_ports                = instrhwinfo('serial');
com_port_av                 = find(ismember(av_com_ports.AvailableSerialPorts,'COM6'));

if isempty(com_port_av)
    fprintf('%s \n','COM6 Port ist nicht verfügbar!');
    return;
end
   

% Open serial interface

open_serial_port( 'COM6', 19200, 8, 'even', 1 );

% Read city_id value in holding register

city_id_reg                 = read_com_set(device_id, {'city_id'});


% Compare city_id and value, if values differ, write the new
% city_id to the relevant register.

[ city_id ]                 = get_city_id( city_name );

if isempty(city_id_reg) == 1
   fprintf('Es befindet sich kein Wert in Register 112!\n');
   write_com_set( device_id, city_id, {'city_id'} );
   fprintf('Neue CityID %u wurde in das Register geschrieben.\nEs wird ein paar Stunden dauern, bis alle Register aktualisiert wurden.\n\n',city_id);
elseif city_id ~= city_id_reg
   write_com_set( device_id, city_id, {'city_id'} );
   fprintf('Neue CityID %u wurde in das Register geschrieben.\nEs wird ein paar Stunden dauern, bis alle Register aktualisiert wurden.\n\n',city_id);
end
    
% If an observation interval is given as argument in the function, varargin
% is not empty. Otherwise only a single request will be generated.
% Get number of requests

    size_table_data         = size(forecast_definition,1);
    
if ~isempty(varargin)

% Decision between a single update call or an automated update cycle
% defined by the start and end date.

    start_observation       = regexp(start_observation,'-','split');
    end_observation         = regexp(end_observation,'-','split');
    update_start_date       = [start_observation{1},'-',start_observation{2},'-',start_observation{3}];
    update_end_date         = [end_observation{1},'-',end_observation{2},'-',end_observation{3}];
    
    diff_days               = days365(update_start_date,update_end_date)*24;
    end_of_day              = datevec(date)+[0 0 0 24 0 0];
    start_of_day            = datevec(now);
    
    if diff_days < 0 
        error(['Das Startdatum für den Beobachtungszeitraum muss vor' ...
              ' dem Enddatum liegen! Bitte korrigieren Sie die Datumseingabe.']);
    elseif days365(date,update_start_date) < 0
        error('Das Startdatum liegt in der Vergangenheit!');
    else
        
% If start date is today you first have to calculate the remaining hours
% till the end of that day, then you have to calculte the difference
% between the start and the end date to receive the number of days.
% Multiply with 24 to get the hours for those days. The number of update
% cycles is calculated then by dividing the sum of available hours round
% down the result and add 1 for the immediate request at time zero.
    if strcmp(update_start_date,date) == 1
        diff_today          = etime(end_of_day,start_of_day)/3600;
        update_cycle_number = floor((diff_today+diff_days)/update_interval)+1;
        assignin('base','update_cycle_number',update_cycle_number);
    else
        diff_today          = etime(end_of_day,start_of_day);
        update_cycle_number = floor(diff_days/update_interval);
        assignin('base','update_cycle_number',update_cycle_number);
    end

% The waiting period for the timer: interval for an update times 3600 sec
    update_interval_hours   = update_interval*15;
   
% A timer is defined here to control the automatic update cycles.
% Requests start with a 3 sec delay. The function to be executed after
% the waiting period is send_loop, which triggers the communication
% between Matlab and the weather station. The stop function deletes the
% timer object after all tasks have been executed. 
    t                       = timer;
    if strcmp(update_start_date,date) == 1
        t.StartDelay            = 3;
    else
        t.StartDelay            = diff_today;
    end
    t.TimerFcn              = {@send_loop, size_table_data, forecast_definition, device_id, filepath, update_cycle_number};
    t.StopFcn               = {@stop_timer, filepath};
    t.Period                = update_interval_hours;
    t.TasksToExecute        = update_cycle_number;
    t.ExecutionMode         = 'fixedSpacing';
    start(t);
    
    end
else
    
    send_loop('','', size_table_data, forecast_definition, device_id, filepath, '');
    filename = strcat(filepath,'\weather_data_',date,'.mat');
    weather_data = evalin('base','weather_data');
    save(filename,'weather_data','-mat');
    close_serial_port();
    
end


end

