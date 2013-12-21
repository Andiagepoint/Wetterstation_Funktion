function [ dec_value ] = data_processing( data_string, field_name, cycle_number )
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
    weather_data{1,size(weather_data,2) + 5}    = [];
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
    dec_value = hex2dec(strcat(dec2hex(data_string(1),2),dec2hex(data_string(2),2)));
    
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
     
    if size(field_name,2) < 5
        
        edindex = sdindex;
        
    else
        
        [~, edindex] = ismember(field_name{5}, obs_day);
        
    end
    
    % Increment initialization for the data loop
    
    data_str_hi_byte_pos = 1;
    data_str_lo_byte_pos = 2;
    
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
                
                if size(field_name,2) < 5
                    
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
        
        if t == sdindex
                datepart                = str2double(regexp(datestr(date,'yyyy-mm-dd'),'-','split'));
                date_str_num            = datenum(date);
                date_str                = datestr(date_str_num,20);
        else 
                datepart                = datepart + [0 0 1];
                date_str_num            = date_str_num + 1;
                date_str                = datestr(date_str_num,20); 
        end
        
        for s = shindex:ehindex

            % Break condition for an completely evaluated data string
            
            if data_str_lo_byte_pos > size(data_string,1)
                
                break;
                
            end
            
            % Evaluation of a 16-bit word, big-Endian
            
            hi_byte                                     = dec2hex(data_string(data_str_hi_byte_pos),2);
            lo_byte                                     = dec2hex(data_string(data_str_lo_byte_pos),2);
            hex_value                                   = strcat(hi_byte,lo_byte);
            dec_value                                   = hex2dec(hex_value);
            
            % Receiving uint bytes, signed bytes will be calculated here
            
            if dec_value > 32768
                dec_value                               = dec_value - 65536;
            end
            
            % Structuring data: forecast details in rows, timestamp and value in columns 
            
            
            if strcmp(field_name{2},'Mittlere_temp_prog')~= 1 
               switch day_segment{s}
                    case 'Morgen'
                       timevec      = [datepart, 0 0 1];
                       time_str     = [date_str,'  ','00:00:01-06:00:00'];
                    case 'Vormittag'
                       timevec      = [datepart, 6 0 1];
                       time_str     = [date_str,'  ','06:00:01-12:00:00'];
                    case 'Nachmittag'
                       timevec      = [datepart, 12 0 1];
                       time_str     = [date_str,'  ','12:00:01-18:00:00'];
                    case 'Abend'    
                       timevec      = [datepart, 18 0 1];
                       time_str     = [date_str,'  ','18:00:01-24:00:00'];
               end
            else
                switch point_in_time{s}
                    case 'AM0_00'
                       timevec = [datepart, 0 0 1]; 
                       time_str     = [date_str,'  ','00:00:01-01:00:00'];
                    case 'AM01_00'
                       timevec = [datepart, 1 0 1];
                       time_str     = [date_str,'  ','01:00:01-02:00:00'];
                    case 'AM02_00'
                       timevec = [datepart, 2 0 1]; 
                       time_str     = [date_str,'  ','02:00:01-03:00:00'];
                    case 'AM03_00'
                       timevec = [datepart, 3 0 1]; 
                       time_str     = [date_str,'  ','03:00:01-04:00:00'];
                    case 'AM04_00'
                       timevec = [datepart, 4 0 1]; 
                       time_str     = [date_str,'  ','04:00:01-05:00:00'];
                    case 'AM05_00'
                       timevec = [datepart, 5 0 1]; 
                       time_str     = [date_str,'  ','05:00:01-06:00:00'];
                    case 'AM06_00'
                       timevec = [datepart, 6 0 1]; 
                       time_str     = [date_str,'  ','06:00:01-07:00:00'];
                    case 'AM07_00'
                       timevec = [datepart, 7 0 1]; 
                       time_str     = [date_str,'  ','07:00:01-08:00:00'];
                    case 'AM08_00'
                       timevec = [datepart, 8 0 1]; 
                       time_str     = [date_str,'  ','08:00:01-09:00:00'];
                    case 'AM09_00'
                       timevec = [datepart, 9 0 1]; 
                       time_str     = [date_str,'  ','09:00:01-10:00:00'];
                    case 'AM10_00'
                       timevec = [datepart, 10 0 1]; 
                       time_str     = [date_str,'  ','10:00:01-11:00:00'];
                    case 'AM11_00'
                       timevec = [datepart, 11 0 1]; 
                       time_str     = [date_str,'  ','11:00:01-12:00:00'];
                    case 'AM12_00'
                       timevec = [datepart, 12 0 1]; 
                       time_str     = [date_str,'  ','12:00:01-13:00:00'];
                    case 'PM01_00'
                       timevec = [datepart, 13 0 1]; 
                       time_str     = [date_str,'  ','13:00:01-14:00:00'];
                    case 'PM02_00'
                       timevec = [datepart, 14 0 1]; 
                       time_str     = [date_str,'  ','14:00:01-15:00:00'];
                    case 'PM03_00'
                       timevec = [datepart, 15 0 1]; 
                       time_str     = [date_str,'  ','15:00:01-16:00:00'];
                    case 'PM04_00'
                       timevec = [datepart, 16 0 1]; 
                       time_str     = [date_str,'  ','16:00:01-17:00:00'];
                    case 'PM05_00'
                       timevec = [datepart, 17 0 1]; 
                       time_str     = [date_str,'  ','17:00:01-18:00:00'];
                    case 'PM06_00'
                       timevec = [datepart, 18 0 1]; 
                       time_str     = [date_str,'  ','18:00:01-19:00:00'];
                    case 'PM07_00'
                       timevec = [datepart, 19 0 1]; 
                       time_str     = [date_str,'  ','19:00:01-20:00:00'];
                    case 'PM08_00'
                       timevec = [datepart, 20 0 1]; 
                       time_str     = [date_str,'  ','20:00:01-21:00:00'];
                    case 'PM09_00'
                       timevec = [datepart, 21 0 1]; 
                       time_str     = [date_str,'  ','21:00:01-22:00:00'];
                    case 'PM10_00'
                       timevec = [datepart, 22 0 1]; 
                       time_str     = [date_str,'  ','22:00:01-23:00:00'];
                    case 'PM11_00'   
                       timevec = [datepart, 23 0 1]; 
                       time_str     = [date_str,'  ','23:00:01-24:00:00'];
                end
            end
            
            
            if size(weather_data,2) < 9
                
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    
                    switch field_name{1}
                        case 'Temperatur'
                            if strcmp(field_name{2},'Min') == 1
                                    weather_data{size_weather_data_r,3} = '�C min. Lufttemperatur 2m �. Erdboden'; 
                            elseif strcmp(field_name{2},'Max') == 1
                                    weather_data{size_weather_data_r,3} = '�C max. Lufttemperatur 2m �. Erdboden';
                            else
                                    weather_data{size_weather_data_r,3} = '�C mittlere Lufttemperatur 2m �. Erdboden';
                            end
                        case 'Niederschlag'
                            if strcmp(field_name{2},'Menge') == 1
                                    weather_data{size_weather_data_r,3} = 'l/m�';
                            else
                                    weather_data{size_weather_data_r,3} = '%';
                            end
                        case 'Solarleistung'
                            if strcmp(field_name{2},'Dauer') == 1
                                    weather_data{size_weather_data_r,3} = 'h';
                            else
                                    weather_data{size_weather_data_r,3} = 'W/m�';
                            end
                        case 'Wind'
                            if strcmp(field_name{2},'Staerke') == 1
                                    weather_data{size_weather_data_r,3} = 'Bft in einer H�he von 10m �. Erdboden';
                            else 
                                    weather_data{size_weather_data_r,3} = 'N/NO/O/SO/S/SW/W/NW -> 1...8';
                            end
                        case 'Luftdruck'
                                    weather_data{size_weather_data_r,3} = 'hPa';
                        case 'Signifikantes_Wetter'
                                    weather_data{size_weather_data_r,3} = '1 = sonnig,klar 2 = leicht bew�lkt 3 = vorwiegend bew�lkt 4 = bedeckt 5 = W�rmegewitter 6 = starker Regen 7 = Schneefall 8 = Nebel 9 = Schneeregen 10 = Regenschauer 11 = leichter Regen 12 = Schneeschauer 13 = Frontengewitter 14 = Hochnebel 15 = Schneeregenschauer';
                        case 'Markantes_Wetter'
                            switch field_name{2}
                                case 'Bodennebel'
                                    weather_data{size_weather_data_r,3} = '1 = Wahrscheinlichkeit > 50%, Sichtweite unter 200m';
                                case 'Gefrierender_Regen'
                                    weather_data{size_weather_data_r,3} = '1 = Wahrscheinlichkeit > 50%';
                                case 'Bodenfrost'
                                    weather_data{size_weather_data_r,3} = '1 = <0�C 5cm �. Erdboden';
                                case 'Boeen'
                                    weather_data{size_weather_data_r,3} = '0 = keine B�en 1 = 45km/h starke B�en 2 = 72km/h st�rmische B�en 3 = 99km/h orkanartige B�en';
                                case 'Niederschlag'
                                    weather_data{size_weather_data_r,3} = '0 = kein starker Niederschlag 1 = 10mm starker Niederschlag 2 = 50mm sehr starker Niederschlag';
                                case 'Hitze'
                                    weather_data{size_weather_data_r,3} = '0 = keine Meldung 1 = 27-31�C 2 = 32-40�C 3 = 41-53�C 4 = >54�C';
                                case 'Kaelte'
                                    weather_data{size_weather_data_r,3} = '0 = keine Meldung 1 = <-15�C 2 = <-20�C 3 = <-25�C 4 = <-30�C';
                            end   
                    end
                         
                    
                    weather_data{size_weather_data_r,4} = time_str;
                    weather_data{size_weather_data_r,5} = date2utc(timevec);
                    weather_data{size_weather_data_r,6} = weather_data{size_weather_data_r,5} + (6*3600-1);
                    weather_data{size_weather_data_r,7} = date2utc(datevec(now));
                    weather_data{size_weather_data_r,8} = data_mult(dec_value,field_name{2});
                    fprintf('%s %s - %s %u %u %u %u \n', field_name{1}, field_name{2}, time_str, date2utc(timevec), weather_data{size_weather_data_r,5} + 6*3600-1, date2utc(datevec(now)), data_mult(dec_value,field_name{2}))
%                     if strcmp(field_name{2},'Mittlere_temp_prog') == 1
%                         
%                         weather_data{size_weather_data_r,4} = time_str;
%                         fprintf('%s %s - %s %u %u %u %u \n', field_name{1}, field_name{2}, time_str, date2utc(timevec), weather_data{size_weather_data_r,5} + 6*3600, date2utc(datevec(now)), data_mult(dec_value,field_name{2}))
%                         
%                     else
%                         
%                         weather_data{size_weather_data_r,4} = time_str;
%                         fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, obs_day{t}, day_segment{s}, date2utc(timevec), data_mult(dec_value,field_name{2}))
%                         
%                     end          
                    
            else

                    new_data{size_new_data_r,1} = field_name{1};
                    new_data{size_new_data_r,2} = field_name{2};
                    
                    switch field_name{1}
                        case 'Temperatur'
                            if strcmp(field_name{2},'Min') == 1
                                    new_data{size_new_data_r,3} = '�C min. Lufttemperatur 2m �. Erdboden'; 
                            elseif strcmp(field_name{2},'Max') == 1
                                    new_data{size_new_data_r,3} = '�C max. Lufttemperatur 2m �. Erdboden';
                            else
                                    new_data{size_new_data_r,3} = '�C mittlere Lufttemperatur 2m �. Erdboden';
                            end
                        case 'Niederschlag'
                            if strcmp(field_name{2},'Menge') == 1
                                    new_data{size_new_data_r,3} = 'l/m�';
                            else
                                    new_data{size_new_data_r,3} = '%';
                            end
                        case 'Solarleistung'
                            if strcmp(field_name{2},'Dauer') == 1
                                    new_data{size_new_data_r,3} = 'h';
                            else
                                    new_data{size_new_data_r,3} = 'W/m�';
                            end
                        case 'Wind'
                            if strcmp(field_name{2},'Staerke') == 1
                                    new_data{size_new_data_r,3} = 'Bft in einer H�he von 10m �. Erdboden';
                            else 
                                    new_data{size_new_data_r,3} = 'N/NO/O/SO/S/SW/W/NW -> 1...8';
                            end
                        case 'Luftdruck'
                                    new_data{size_new_data_r,3} = 'hPa';
                        case 'Signifikantes_Wetter'
                                    new_data{size_new_data_r,3} = '1 = sonnig,klar 2 = leicht bew�lkt 3 = vorwiegend bew�lkt 4 = bedeckt 5 = W�rmegewitter 6 = starker Regen 7 = Schneefall 8 = Nebel 9 = Schneeregen 10 = Regenschauer 11 = leichter Regen 12 = Schneeschauer 13 = Frontengewitter 14 = Hochnebel 15 = Schneeregenschauer';
                        case 'Markantes_Wetter'
                            switch field_name{2}
                                case 'Bodennebel'
                                    new_data{size_new_data_r,3} = '1 = Wahrscheinlichkeit > 50%, Sichtweite unter 200m';
                                case 'Gefrierender_Regen'
                                    new_data{size_new_data_r,3} = '1 = Wahrscheinlichkeit > 50%';
                                case 'Bodenfrost'
                                    new_data{size_new_data_r,3} = '1 = <0�C 5cm �. Erdboden';
                                case 'Boeen'
                                    new_data{size_new_data_r,3} = '0 = keine B�en 1 = 45km/h starke B�en 2 = 72km/h st�rmische B�en 3 = 99km/h orkanartige B�en';
                                case 'Niederschlag'
                                    new_data{size_new_data_r,3} = '0 = kein starker Niederschlag 1 = 10mm starker Niederschlag 2 = 50mm sehr starker Niederschlag';
                                case 'Hitze'
                                    new_data{size_new_data_r,3} = '0 = keine Meldung 1 = 27-31�C 2 = 32-40�C 3 = 41-53�C 4 = >54�C';
                                case 'Kaelte'
                                    new_data{size_new_data_r,3} = '0 = keine Meldung 1 = <-15�C 2 = <-20�C 3 = <-25�C 4 = <-30�C';
                            end   
                    end                
                    new_data{size_new_data_r,4}         = time_str;
                    new_data{size_new_data_r,5}         = date2utc(timevec);
                    new_data{size_new_data_r,6}         = new_data{size_new_data_r,5} + (6*3600-1);
                    new_data{size_new_data_r,7}         = date2utc(datevec(now));
                    new_data{size_new_data_r,8}         = data_mult(dec_value,field_name{2});
                    
            end

            % Incrementing data string, and data container row position 
            
            data_str_hi_byte_pos                        = data_str_hi_byte_pos + 2;
            data_str_lo_byte_pos                        = data_str_lo_byte_pos + 2;
%             pause(0.1)
            size_weather_data_r                         = size_weather_data_r + 1;
            
            if size(weather_data,2) > 9
                size_new_data_r                         = size_new_data_r + 1;
            end
            
        end
    end
    
    % Assign data container to base workspace
    
    assignin('base','new_data',new_data);
    assignin('base','weather_data',weather_data);
    
end

end

