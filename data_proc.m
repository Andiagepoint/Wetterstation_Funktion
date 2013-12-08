function [ dec_value ] = data_proc( value, reg_address, field_name, cycle_number )
% Processes the rxdata and allocates it to the data container in a defined
% structure
%   Detailed explanation goes here


% Get the register data and weather data container form the base workspace

data = evalin('base','data');
weather_data = evalin('base','weather_data');

% Container building: for the first request session (=modbus-message)
% set the row counter to 1 for both weather and new data container
% extent the weather data container to a 1,6 cell array and define the new
% data container as a 1,2 cell array. After the first request is finished
% both cell arrays will contain the response for the send message. For the
% following requests we have to receive the new data array from the base
% workspace and set the row counter to the next free row.

if cycle_number == 1
    size_weather_data_r                         = 1;
    size_new_data_r                             = 1;
    weather_data{1,size(weather_data,2) + 2}    = [];
    size_weather_data_c                         = size(weather_data,2);
    new_data                                    = cell(1,2);
else
    new_data                                    = evalin('base','new_data');
    size_weather_data_r                         = size(weather_data,1) + 1;
    size_new_data_r                             = size(new_data,1) + 1;
end

% Here lists are defined which will be needed to define the loop numbers or
% to find the right register address

obs_day            = {'Heute' 'Erster_Folgetag' 'Zweiter_Folgetag' 'Dritter_Folgetag'};
day_segment     = {'Morgen' 'Vormittag' 'Nachmittag' 'Abend'};
point_in_time  = {'AM0_00' 'AM01_00' 'AM02_00' 'AM03_00' 'AM04_00' ...
                   'AM05_00' 'AM06_00' 'AM07_00' 'AM08_00' 'AM09_00' ...
                   'AM10_00' 'AM11_00' 'AM12_00' 'PM01_00' 'PM02_00' ...
                   'PM03_00' 'PM04_00' 'PM05_00' 'PM06_00' 'PM07_00' ...
                   'PM08_00' 'PM09_00' 'PM10_00' 'PM11_00'};
com_settings    = {'temperature_offset','temperature','city_id', ...
                   'transmitting_station','quality','fsk_qualitaet' ...
                   'status_ext_temp_sensor' 'reserve1' 'reserve2' 'reserve3'};

% If no weather data are requested, but communication specific values the
% if condition is true. Otherwise weather data will be processed.

if strcmp('data.Communication_Settings',field_name) == 1
    dec_value = hex2dec(strcat(dec2hex(value(1),2),dec2hex(value(2),2)));
    
    % As we have an unsigned value from the message, we have to convert
    % it to a signed value, which means FFFF or 65535 stands for -1
    
    if dec_value > 32768
        dec_value = dec_value - 65536;
    end
    
else
    
    % sdindex = starting point of the loop through the observation days
    % edindex = end point 
    % If condition is true only one day will be observed, the loop for
    % observation days will be run only once. 
    % If condition is false, number of loops will be determined by the list
    % position (obs_day) of the last day of observation.
    
    [~, sdindex] = ismember(field_name{3}, obs_day);
     
    if size(field_name,2) < 4
        
        edindex = sdindex;
        
    else
        
        [~, edindex] = ismember(field_name{5}, obs_day);
        
    end
    
    % Increment initialization for the data loop
    
    lfvara = 1;
    lfvare = 2;
    
    % Loop through response data
    
    for t = sdindex:edindex
       
        % With the first day of observation, determine the starting point
        % of the observation day segment or point in time
        % (Mittlere_temp_prog)
        
        if t == sdindex
            
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    [~, shindex] = ismember(field_name{4}, point_in_time);
                    
                else
                    
                    [~, shindex] = ismember(field_name{4}, day_segment);
                    
                end
                
                if size(field_name,2) < 4
                    
                    ehindex         = shindex;
                    
                elseif strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    ehindex         = 24;
                    
                else
                    
                    ehindex         = 4;
                    
                end
                
        elseif t == edindex
            
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    [~, ehindex] = ismember(field_name{6}, point_in_time);
                    
                else
                    
                    [~, ehindex] = ismember(field_name{6}, day_segment);
                    
                end
                
                shindex             = 1;
                
        else
            
                shindex             = 1;
                
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    ehindex         = 24;
                    
                else
                    
                    ehindex         = 4;
                    
                end
                
        end
        
        for s = shindex:ehindex

            if lfvare > size(value,1)
                
                break;
                
            end
            
            hi_byte         = dec2hex(value(lfvara),2);
            lo_byte         = dec2hex(value(lfvare),2);
            hex_value       = strcat(hi_byte,lo_byte);
            dec_value       = hex2dec(hex_value);
            
            if dec_value > 32768
                dec_value   = dec_value - 65536;
            end
            
            
            if strcmp(field_name{2},'Mittlere_temp_prog')==1
                if size(weather_data,2) < 7
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    weather_data{size_weather_data_r,3} = obs_day{t};
                    weather_data{size_weather_data_r,4} = point_in_time{s};
                    weather_data{size_weather_data_r,5} = date2utc(datevec(now));
                    weather_data{size_weather_data_r,6} = data_mult(dec_value,field_name{2});
                else
                    new_data{size_new_data_r,1}         = date2utc(datevec(now));
                    new_data{size_new_data_r,2}         = data_mult(dec_value,field_name{2});          
                end
                fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, obs_day{t}, point_in_time{s}, date2utc(datevec(now)), data_mult(dec_value,field_name{2}))
            else
                if size(weather_data,2) < 7
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    weather_data{size_weather_data_r,3} = obs_day{t};
                    weather_data{size_weather_data_r,4} = day_segment{s};
                    weather_data{size_weather_data_r,5} = date2utc(datevec(now));
                    weather_data{size_weather_data_r,6} = data_mult(dec_value,field_name{2});
                else
                    new_data{size_new_data_r,1}         = date2utc(datevec(now));
                    new_data{size_new_data_r,2}         = data_mult(dec_value,field_name{2});
                end
                fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, obs_day{t}, day_segment{s}, date2utc(datevec(now)), data_mult(dec_value,field_name{2}))
            end

            lfvara              = lfvara + 2;
            lfvare              = lfvare + 2;
            pause(0.1)
            size_weather_data_r = size_weather_data_r + 1;
            if size(weather_data,2) > 6
                size_new_data_r = size_new_data_r + 1;
            end
        end
    end
    assignin('base','new_data',new_data);
    assignin('base','weather_data',weather_data);
end
end

