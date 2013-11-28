function [ output_args ] = forecast_data( city_name, forecast_definition, varargin )
% Example
% forecast_data('München','Niederschlag-Menge-Heute-Morgen-Dritter_Folgetag-Abend','23-25-Nov-2013','1')
%   Detailed explanation goes here

if ~isempty(varargin)
    observation_period      = varargin{1};
    resolution              = varargin{2};
    update_interval         = varargin{3};
end

evalin('base',['load(''C:\Users\AndiPower\Documents\MATLAB\Wetterstation_Funktion\weather_station_data.mat'')']);

if evalin('base', ['exist(''serial_interface'')']) == 1
    evalin('base', ['delete(''serial_interface'')']);
    evalin('base', 'clear serial_interface');
    evalin('base', 'delete(instrfind)');
end

% General variable settings

device_id                   = '03';


% Adresse für die Wetterregion in Holdingregister 112
% Adresse für die Sendestation in Holdingregister 110

reg_add_weather_region      = {'city_id'};
reg_add_station_location    = {'transmitting_station'};


% Check for available COM Ports

av_com_ports                = instrhwinfo('serial');
com_port_av                 = find(ismember(av_com_ports.AvailableSerialPorts,'COM6'));

if isempty(com_port_av)
    fprintf('%s \n','COM Port ist nicht verfügbar');
    return;
end
   

% Open serial interface

open_serial_port( 'COM6', 9600, 8, 'none', 1 );


% Read city_id value in holding register

city_id_reg                 = read_sr(device_id, reg_add_weather_region);


% Compare city_id and value, if values differ, write the new
% city_id to the relevant register.

[ city_id ]                 = get_city_id( city_name );

if city_id ~= city_id_reg
   write_sr( device_id, city_id, reg_add_weather_region );
   fprintf('Neue CityID %u wurde in das Register geschrieben.\nEs wird ein paar Stunden dauern, bis alle Register aktualisiert wurden.\n\n',city_id);
end


% Create cell array for data aquisition
    weather_data            = cell(1,4);
    assignin('base','weather_data',weather_data);
    new_data                = cell(1,2);
    assignin('base','new_data',new_data);
    
    size_table_data         = size(forecast_definition,1);
    
% If update checkbox is activated update_checkbox will be 1.
if ~isempty(varargin)

% Decision between a single update call or an automated update cycle
% defined by the start and end date.

    observation_period      = regexp(observation_period,'-','split');
    update_start_date       = [observation_period{1},'-',observation_period{3},'-',observation_period{4}];
    update_end_date         = [observation_period{2},'-',observation_period{3},'-',observation_period{4}];

% If start date is today you first have to calculate the remaining hours
% till the end of that day, then you have to calculte the difference
% between the start and the end date to receive the number of days.
% Multiply with 24 to get the hours for those days. The number of update
% cycles is calculated then by dividing the sum of available hours round
% down the result and add 1 for the immediate request at time zero.
    if strcmp(update_start_date,date) == 1
        end_of_day          = datevec(date)+[0 0 0 24 0 0];
        start_of_day        = datevec(now);
        diff_today          = etime(end_of_day,start_of_day)/3600;
        diff_days           = days365(update_start_date,update_end_date)*24;
        update_cycle_number = floor((diff_today+diff_days)/update_interval)+1;
    else
        diff_days           = days365(update_start_date,update_end_date)*24;
        update_cycle_number = floor(diff_days/update_interval);
    end

% The waiting period for the timer: interval for an update times 3600 sec
    update_interval_hours   = update_interval*15;    
    
% A timer is defined here to control the automatic update cycles.
% Requests start with a 3 sec delay. The function to be executed after
% the waiting period is send_loop, which triggers the communication
% between Matlab and the weather station. The stop function deletes the
% timer object after all tasks have been executed. 
    t                       = timer;
    t.StartDelay            = 3;
    t.TimerFcn              = {@send_loop, size_table_data, forecast_definition, device_id};
    t.StopFcn               = @stop_timer;
    t.Period                = update_interval_hours;
    t.TasksToExecute        = update_cycle_number;
    t.ExecutionMode         = 'fixedSpacing';
    start(t);
    
else
    
    send_loop('','', size_table_data, {forecast_definition}, device_id);
    
end


end

