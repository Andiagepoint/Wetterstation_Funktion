function [ ] = forecast_data( city_name, forecast_definition, varargin )
% Function to read data from HWK Kompakt WS-xx Modbus
% Example
% forecast_data('München','Niederschlag-Menge-Heute-Morgen-Dritter_Folgetag-Abend','23-Nov-2013-25-Nov-2013',1,6)
% forecast_data('München','Luftdruck--Heute-Morgen-Heute-Abend','23-Nov-2013-23-Nov-2013',1,6)
% forecast_data('München',cell_array,'23-Nov-2013-23-Nov-2013',1,6)
%
%   Function to get the forecast data provided by the weather station HWK
%   Kompakt. The arguments for this function are CITY NAME (available in
%   the city_list), specific FORECAST DATA and INTERVAL, OBSERVATION
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


% Assign varargin elements to variables. Create folder to save records.

if ~isempty(varargin)
    start_observation       = varargin{1};
    end_observation         = varargin{2};
    resolution              = varargin{3};
    update_interval         = varargin{4};
    if size(varargin,2) > 4
        filepath            = varargin{5};
    else
        if size(pwd,2) < 4
            filepath        = [pwd,'Aufzeichnungen'];
        else
            filepath        = [pwd,'\Aufzeichnungen']; 
        end
        [s,mess,messid]     = mkdir(filepath);
        if ~isempty(mess)
            fprintf('Ordner existiert bereits.\n');
        end
    end
end

% Create a table with all available forecast definitions.

if strcmp(forecast_definition,'all') == 1
    forecast_definition = create_table();
end

% If only one forecast definition is requested, convert char input into
% cell array.

if ~iscell(forecast_definition)
    forecast_definition = {forecast_definition};
end

% Determine the number of requests.

size_table_data         = size(forecast_definition,1);

% Set daychange to 0

daychange = 0;

% Split the datestring into single elements 
  
start_observation       = regexp(start_observation,'-','split');
end_observation         = regexp(end_observation,'-','split');

% 
update_start_date       = [start_observation{1},'-',start_observation{2},'-',start_observation{3}];
update_end_date         = [end_observation{1},'-',end_observation{2},'-',end_observation{3}];

% Create the structure with all register addresses 
data = create_reg_data();

% Create the list with all available city ids
city_list = create_city_list;

% Assign both created structures to base workspace
assignin('base','register_data_hwk_kompakt',data);
assignin('base','city_list',city_list);

% Initalize or reset with new function call data container
weather_data = [];
new_data = [];
    
% Input check, if all inputs are correct, create data container, else print
% error message.
for z = 1:size_table_data
    [correct_input, error_msg, city_id] = input_check(forecast_definition{z}, update_start_date, update_end_date, city_name, resolution);
    if true(correct_input)
        
        weather_data = create_data_struct(forecast_definition{z}, weather_data, 'weather_data');
        new_data = create_data_struct(forecast_definition{z}, new_data, 'new_data');
        
    else
    
        fprintf(2,'%s\n%s\n%s\n%s\n%s\n%s\n', error_msg{1}, error_msg{2}, error_msg{3}, error_msg{4}, error_msg{5}, error_msg{6}, error_msg{7}, char(10))
        error('Die oben aufgeführten Eingabeparameter sind nicht korrekt.');
    
    end
end

% Check whether a variable serial interface already exists in the base 
% workspace. If true delete this variable and all other available serial
% interfaces to be sure to build up the neccessary serial interface.
if evalin('base', ('exist(''serial_interface'')')) == 1
    evalin('base', ('delete(''serial_interface'')'));
    evalin('base', 'clear serial_interface');
    evalin('base', 'delete(instrfind)');
end

% Set device id

device_id                   = '03';

% Assign data container to base workspace. In the base workspace now the 
% city_list, the data container, the serial interface and the register
% address structure are available.

assignin('base','weather_data',weather_data);
assignin('base','new_data',new_data);

% Check for available COM Ports, if COM6 is not available print message

av_com_ports                = instrhwinfo('serial');
com_port_av                 = find(ismember(av_com_ports.AvailableSerialPorts,'COM6'));

if isempty(com_port_av)
    fprintf('%s \n','COM6 Port ist nicht verfügbar!');
    return;
end

% Open serial interface

open_serial_port( 'COM6', 19200, 8, 'even', 1 );

% Read actual city_id value in holding register

city_id_reg                 = read_com_set(device_id, {'city_id'});

% If no value is detected for the city id register, the required city id
% will be written to that register. If the existent register value doesn´t
% match the required value it will be overwritten. 

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

if ~isempty(varargin)

% Calculate day difference in hours between the observation start date and 
% end date. Further determine start and end date of current day.

    diff_days               = days365(update_start_date,update_end_date)*24;
    end_of_day              = datevec(date)+[0 0 0 24 0 0];
    start_of_day            = datevec(now);

% When the observation start date equals current date, calculate the
% remaining hours from calling the function to the end of current day. The
% number of update cycles results from the sum of remaining hours from the
% current day and hours between the days after current day to end of
% observation divided by the update interval. You have to add 1 for the
% first request executed immediatly with this function call.
% If the observation start date is in the future, and observation start
% date and end date are equal, 24 hours are available. Update cycle number 
% is the result of the division diffdays/update_interval. Start delay is
% calculated from the sum of remaining hours of current date and difference
% of days in hours till start of observation. 

    if strcmp(update_start_date,date) == 1

        diff_today              = etime(end_of_day,start_of_day)/3600;
        update_cycle_number     = floor((diff_today+diff_days)/update_interval)+1;
        assignin('base','update_cycle_number',update_cycle_number);

    else

        if datenum(update_start_date) == datenum(update_end_date)

            diff_days           = 24;

        end

            diff_today          = etime(end_of_day,start_of_day);
            diff_days2start     = days365(date,update_start_date);
            start_delay         = uint32(diff_today+diff_days2start*86400);
            update_cycle_number = floor(diff_days/update_interval);
            assignin('base','update_cycle_number',update_cycle_number);
            
    end

% The waiting period for the timer: interval for an update times 3600 sec
    update_interval_hours       = update_interval*3600;

% A timer is defined here to control the automatic update cycles.
% Requests start with a 3 sec delay. The function to be executed after
% the waiting period is send_loop, which triggers the communication
% between Matlab and the weather station. The stop function deletes the
% timer object after all tasks have been executed. 
    t                           = timer;

    if strcmp(update_start_date,date) == 1

        t.StartDelay            = 3;

    else

        t.StartDelay            = start_delay;

    end
    t.BusyMode                  = 'drop';
    t.TimerFcn                  = {@send_loop, size_table_data, forecast_definition, device_id, filepath, city_name, update_cycle_number, resolution, daychange};
    t.StopFcn                   = {@stop_timer, filepath, city_name, resolution};
    t.Period                    = update_interval_hours;
    t.TasksToExecute            = update_cycle_number;
    t.ExecutionMode             = 'fixedSpacing';
    start(t);

else

    send_loop('','', size_table_data, forecast_definition, device_id, filepath, city_name, '', resolution, daychange);
    filename                    = strcat(filepath,'\weather_data_',date,'.mat');
    weather_data                = evalin('base','weather_data');
    save(filename,'weather_data','-mat');
    close_serial_port();

end
    
end

