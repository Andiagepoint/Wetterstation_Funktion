function [ dec_value ] = data_processing( value, field_name, cycle_number )
% Processes the rxdata and allocates it to the data container in a defined
% structure
%   Detailed explanation goes here


% Get the register data and weather data container form the base workspace

% register_data_hwk_kompakt = evalin('base','register_data_hwk_kompakt');
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

if strcmp('register_data_hwk_kompakt.Communication_Settings',field_name) == 1
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
                
                % Starting point for the first observation day
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    [~, shindex] = ismember(field_name{4}, point_in_time);
                    
                else
                    
                    [~, shindex] = ismember(field_name{4}, day_segment);
                    
                end
                
                % End point for the first observation day will either be
                % the starting point, when only one value is requested, or
                % the entire intervall (24,4), which will be stopped at when
                % the data string is completely evaluated.
                
                if size(field_name,2) < 4
                    
                    ehindex         = shindex;
                    
                elseif strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    ehindex         = 24;
                    
                else
                    
                    ehindex         = 4;
                    
                end
                
        elseif t == edindex
                
                % If more then one day is observed we have in any case at
                % least a starting index of 1. The ending point is
                % determined through the list position in point_in_time or
                % day_segment.
                
                shindex             = 1;
                
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    [~, ehindex] = ismember(field_name{6}, point_in_time);
                    
                else
                    
                    [~, ehindex] = ismember(field_name{6}, day_segment);
                    
                end
                
        else
            
                % If the observation intervall exceeds more than two days,
                % the starting point and end point are defined over the
                % complete forecast intervall for the days between start
                % and end day. 
            
                shindex             = 1;
                
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    
                    ehindex         = 24;
                    
                else
                    
                    ehindex         = 4;
                    
                end
                
        end
        
        for s = shindex:ehindex

            % Break condition for an completely evaluated data string
            
            if lfvare > size(value,1)
                
                break;
                
            end
            
            % Evaluation of a 16-bit word, big-Endian
            
            hi_byte                                     = dec2hex(value(lfvara),2);
            lo_byte                                     = dec2hex(value(lfvare),2);
            hex_value                                   = strcat(hi_byte,lo_byte);
            dec_value                                   = hex2dec(hex_value);
            
            % Receiving uint bytes, signed bytes will be calculated here
            
            if dec_value > 32768
                dec_value                               = dec_value - 65536;
            end
            
            % Structuring data: forecast details in rows, timestamp and value in columns 
            
            datepart = str2double(regexp(datestr(date,'yyyy-mm-dd'),'-','split'));
            
            if strcmp(field_name{2},'Mittlere_temp_prog')~= 1 
               switch day_segment{s}
                    case 'Morgen'
                       timevec = [datepart, 0 0 0];
                    case 'Vormittag'
                       timevec = [datepart, 6 0 0];
                    case 'Nachmittag'
                       timevec = [datepart, 12 0 0];
                    case 'Abend'    
                       timevec = [datepart, 18 0 0];
               end
            else
                switch point_in_time{s}
                    case 'AM0_00'
                       timevec = [datepart, 0 0 0]; 
                    case 'AM01_00'
                       timevec = [datepart, 1 0 0]; 
                    case 'AM02_00'
                       timevec = [datepart, 2 0 0]; 
                    case 'AM03_00'
                       timevec = [datepart, 3 0 0]; 
                    case 'AM04_00'
                       timevec = [datepart, 4 0 0]; 
                    case 'AM05_00'
                       timevec = [datepart, 5 0 0]; 
                    case 'AM06_00'
                       timevec = [datepart, 6 0 0]; 
                    case 'AM07_00'
                       timevec = [datepart, 7 0 0]; 
                    case 'AM08_00'
                       timevec = [datepart, 8 0 0]; 
                    case 'AM09_00'
                       timevec = [datepart, 9 0 0]; 
                    case 'AM10_00'
                       timevec = [datepart, 10 0 0]; 
                    case 'AM11_00'
                       timevec = [datepart, 11 0 0]; 
                    case 'AM12_00'
                       timevec = [datepart, 12 0 0]; 
                    case 'PM01_00'
                       timevec = [datepart, 13 0 0]; 
                    case 'PM02_00'
                       timevec = [datepart, 14 0 0]; 
                    case 'PM03_00'
                       timevec = [datepart, 15 0 0]; 
                    case 'PM04_00'
                       timevec = [datepart, 16 0 0]; 
                    case 'PM05_00'
                       timevec = [datepart, 17 0 0]; 
                    case 'PM06_00'
                       timevec = [datepart, 18 0 0]; 
                    case 'PM07_00'
                       timevec = [datepart, 19 0 0]; 
                    case 'PM08_00'
                       timevec = [datepart, 20 0 0]; 
                    case 'PM09_00'
                       timevec = [datepart, 21 0 0]; 
                    case 'PM10_00'
                       timevec = [datepart, 22 0 0]; 
                    case 'PM11_00'   
                       timevec = [datepart, 23 0 0]; 
                end
            end
            
            
            if size(weather_data,2) < 7
                
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    weather_data{size_weather_data_r,3} = obs_day{t};
                    weather_data{size_weather_data_r,5} = date2utc(timevec);
                    weather_data{size_weather_data_r,6} = data_mult(dec_value,field_name{2});
                    
                    if strcmp(field_name{2},'Mittlere_temp_prog')==1
                        
                        weather_data{size_weather_data_r,4} = point_in_time{s};
                        fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, obs_day{t}, point_in_time{s}, date2utc(timevec), data_mult(dec_value,field_name{2}))
                        
                    else
                        
                        weather_data{size_weather_data_r,4} = day_segment{s};
                        fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, obs_day{t}, day_segment{s}, date2utc(timevec), data_mult(dec_value,field_name{2}))
                        
                    end          
                    
            else
                
                    new_data{size_new_data_r,1}         = date2utc(timevec);
                    new_data{size_new_data_r,2}         = data_mult(dec_value,field_name{2});
                    
            end

            % Incrementing data string, and data container row position 
            
            lfvara                                      = lfvara + 2;
            lfvare                                      = lfvare + 2;
%             pause(0.1)
            size_weather_data_r                         = size_weather_data_r + 1;
            
            if size(weather_data,2) > 6
                size_new_data_r                         = size_new_data_r + 1;
            end
            
        end
    end
    
    % Assign data container to base workspace
    
    assignin('base','new_data',new_data);
    assignin('base','weather_data',weather_data);
    
end

end

