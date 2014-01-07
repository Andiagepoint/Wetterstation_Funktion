function [ dec_value ] = data_processing( data_string, field_name, resolution )
% Processes the rxdata and allocates it to the data container in a defined
% structure
%   Detailed explanation goes here


% Get the register data and weather data container form the base workspace

% register_data_hwk_kompakt = evalin('base','register_data_hwk_kompakt');

weather_data = evalin('base','weather_data');
new_data = evalin('base','new_data');

% Container building: for the first request session (=modbus-message)
% set the row counter to 1 for both weather and new data container
% extent the weather data container to a 1,6 cell array and define the new
% data container as a 1,2 cell array. After the first request is finished
% both cell arrays will contain the response for the send message. For the
% following requests we have to receive the new data array from the base
% workspace and set the row counter to the next free row.


% Here lists are defined which will be needed to define the loop numbers or
% to find the right register address

obs_day         = {'heute' 'erster_folgetag' 'zweiter_folgetag' 'dritter_folgetag'};
day_segment     = {'morgen' 'vormittag' 'nachmittag' 'abend'};
point_in_time   = {'am0_00' 'am01_00' 'am02_00' 'am03_00' 'am04_00' ...
                   'am05_00' 'am06_00' 'am07_00' 'am08_00' 'am09_00' ...
                   'am10_00' 'am11_00' 'am12_00' 'pm01_00' 'pm02_00' ...
                   'pm03_00' 'pm04_00' 'pm05_00' 'pm06_00' 'pm07_00' ...
                   'pm08_00' 'pm09_00' 'pm10_00' 'pm11_00'};
com_settings    = {'temperature_offset','temperature','city_id', ...
                   'transmitting_station','quality','fsk_qualitaet' ...
                   'status_ext_temp_sensor' 'reserve1' 'reserve2' 'reserve3'};

% If no weather data are requested, but communication specific values the
% if condition is true. Otherwise weather data will be processed.

if strcmp('register_data_hwk_kompakt.communication_settings',field_name) == 1
    dec_value = hex2dec(strcat(dec2hex(data_string(1),2),dec2hex(data_string(2),2)));
    
    % As we have an unsigned value from the message, we have to convert
    % it to a signed value, which means FFFF or 65535 stands for -1
    
    if dec_value > 32768
        dec_value = dec_value - 65536;
    end
    
else
    
    time_record = [];
    i           = 1;
    new_data_r  = 1;
    
    if ~isempty(weather_data.(field_name{1}).(field_name{2}).unix_time_record)
        time_record = weather_data.(field_name{1}).(field_name{2}).unix_time_record(size(weather_data.(field_name{1}).(field_name{2}).value,2));
    end
    
    if isempty(time_record)
        weather_data_r = 1;
    else
%         if date2utc(datevec(now))-time_record < 60  
%             datetest = '06-Jan-2014';
%         else
%             datetest = '07-Jan-2014';
%         end
        if datestr(utc2date(time_record),1) == date
            weather_data_r = 1;
        else
            while strcmp(datestr(utc2date(weather_data.(field_name{1}).(field_name{2}).unix_time_start(i)),1),date) ~= 1
                i = i + 1;
                if i > size(weather_data.(field_name{1}).(field_name{2}).unix_time_start,2)
                    break;
                end
            end
            weather_data_r = i;
        end
    end

    
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
                if strcmp(field_name{2},'mittlere_temp_prog')==1
                    
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
                    
                elseif strcmp(field_name{2},'mittlere_temp_prog')==1
                    
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
                
                if strcmp(field_name{2},'mittlere_temp_prog')==1
                    
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
                
                if strcmp(field_name{2},'mittlere_temp_prog')==1
                    
                    ehindex         = 24;
                    
                else
                    
                    ehindex         = 4;
                    
                end
                
        end
        
        if t == sdindex
                datepart                = str2double(regexp(datestr(date,'yyyy-mm-dd'),'-','split'));
                date_str_num            = datenum(date);
        else 
                datepart                = datepart + [0 0 1];
                date_str_num            = date_str_num + 1;
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
            
            
            if strcmp(field_name{2},'mittlere_temp_prog') ~= 1 
               switch day_segment{s}
                    case 'morgen'
                       timevec      = [datepart, 0 0 1];
                    case 'vormittag'
                       timevec      = [datepart, 6 0 1];
                    case 'nachmittag'
                       timevec      = [datepart, 12 0 1];
                    case 'abend'    
                       timevec      = [datepart, 18 0 1];
               end
            else
                switch point_in_time{s}
                    case 'am0_00'
                       timevec = [datepart, 0 0 1]; 
                    case 'am01_00'
                       timevec = [datepart, 1 0 1];
                    case 'am02_00'
                       timevec = [datepart, 2 0 1]; 
                    case 'am03_00'
                       timevec = [datepart, 3 0 1]; 
                    case 'am04_00'
                       timevec = [datepart, 4 0 1]; 
                    case 'am05_00'
                       timevec = [datepart, 5 0 1]; 
                    case 'am06_00'
                       timevec = [datepart, 6 0 1]; 
                    case 'am07_00'
                       timevec = [datepart, 7 0 1]; 
                    case 'am08_00'
                       timevec = [datepart, 8 0 1]; 
                    case 'am09_00'
                       timevec = [datepart, 9 0 1]; 
                    case 'am10_00'
                       timevec = [datepart, 10 0 1]; 
                    case 'am11_00'
                       timevec = [datepart, 11 0 1]; 
                    case 'am12_00'
                       timevec = [datepart, 12 0 1]; 
                    case 'pm01_00'
                       timevec = [datepart, 13 0 1]; 
                    case 'pm02_00'
                       timevec = [datepart, 14 0 1]; 
                    case 'pm03_00'
                       timevec = [datepart, 15 0 1]; 
                    case 'pm04_00'
                       timevec = [datepart, 16 0 1]; 
                    case 'pm05_00'
                       timevec = [datepart, 17 0 1]; 
                    case 'pm06_00'
                       timevec = [datepart, 18 0 1]; 
                    case 'pm07_00'
                       timevec = [datepart, 19 0 1]; 
                    case 'pm08_00'
                       timevec = [datepart, 20 0 1]; 
                    case 'pm09_00'
                       timevec = [datepart, 21 0 1]; 
                    case 'pm10_00'
                       timevec = [datepart, 22 0 1]; 
                    case 'pm11_00'   
                       timevec = [datepart, 23 0 1]; 
                end
            end
            
                weather_data.(field_name{1}).(field_name{2}).unix_time_start(weather_data_r)        = date2utc(timevec);
                weather_data.(field_name{1}).(field_name{2}).unix_time_end(weather_data_r)          = (date2utc(timevec) + (6*3600-1));
                weather_data.(field_name{1}).(field_name{2}).unix_time_record(weather_data_r)       = date2utc(datevec(now));
                weather_data.(field_name{1}).(field_name{2}).interval_time_clear{weather_data_r}    = {[' ',utc2date(date2utc(timevec)),'-',datestr(utc2date(date2utc(timevec) + (6*3600-1)),13)]};
                weather_data.(field_name{1}).(field_name{2}).value(weather_data_r)                  = data_mult(dec_value,field_name{2});
                
                fprintf('%s %s - %u %u %u %s %u \n', field_name{1}, field_name{2}, date2utc(timevec), date2utc(timevec) + (6*3600-1), date2utc(datevec(now)), strcat(utc2date(date2utc(timevec)),'-',datestr(utc2date(date2utc(timevec) + (6*3600-1)),13)), data_mult(dec_value,field_name{2}));                     

                new_data.(field_name{1}).(field_name{2}).unix_time_start(new_data_r)        = date2utc(timevec);
                new_data.(field_name{1}).(field_name{2}).unix_time_end(new_data_r)          = date2utc(timevec) + (6*3600-1);
                new_data.(field_name{1}).(field_name{2}).unix_time_record(new_data_r)       = date2utc(datevec(now));
                new_data.(field_name{1}).(field_name{2}).interval_time_clear{new_data_r}    = {[' ',utc2date(date2utc(timevec)),'-',datestr(utc2date(date2utc(timevec) + (6*3600-1)),13)]};
                new_data.(field_name{1}).(field_name{2}).value(new_data_r)                  = data_mult(dec_value,field_name{2});
                   
            % Incrementing data string, and data container row position 
            
            data_str_hi_byte_pos = data_str_hi_byte_pos + 2;
            data_str_lo_byte_pos = data_str_lo_byte_pos + 2;
            
            weather_data_r       = weather_data_r + 1;
            new_data_r           = new_data_r + 1;
            
        end
    end
    
    
    
    if resolution == 6
    % Assign data container to base workspace
    
        assignin('base','new_data',new_data);
        assignin('base','weather_data',weather_data);
    
    else
        
        if strcmp(field_name{1},'markantes_wetter') == 1 || strcmp(field_name{1},'signifikantes_wetter') == 1 || strcmp(field_name{2},'richtung') == 1 || strcmp(field_name{2},'wahrscheinlichkeit') == 1
            assignin('base','new_data',new_data);
            assignin('base','weather_data',weather_data);
        else
            switch resolution
                case 1
                    factor = 6;
                case 0.5
                    factor = 12;
                case 0.25
                    factor = 24;
            end
            
            temp_data_y = double(new_data.(field_name{1}).(field_name{2}).value(1,1:end)');
            temp_data_x = double(new_data.(field_name{1}).(field_name{2}).unix_time_start(1,1:end)');
            
            if i == 1
                
                data_end = size(new_data.(field_name{1}).(field_name{2}).unix_time_start,2)*factor - 1;
                
            else
                
                data_end = i - 1 + size(new_data.(field_name{1}).(field_name{2}).unix_time_start,2)*factor - 1;
                
            end
            
            if strcmp(field_name{2},'mittlere_temp_prog') == 1 && factor == 6
                
                if strcmp(field_name{1},'temperatur') == 1
                    slm = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0); 
                    slm_new = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                else
                    slm = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','minvalue',min(weather_data.(field_name{1}).(field_name{2}).value(1,i:end)),'leftslope',0,'rightslope',0);
                    slm_new = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','minvalue',min(new_data.(field_name{1}).(field_name{2}).value(1,1:end)),'leftslope',0,'rightslope',0);
                end

                for u = i:data_end+1
                   weather_data.(field_name{1}).(field_name{2}).value(1,u) = slmeval(weather_data.(field_name{1}).(field_name{2}).unix_time_start(1,u),slm); 
                end

                for u = 1:size(new_data.(field_name{1}).(field_name{2}).unix_time_start,2)
                   new_data.(field_name{1}).(field_name{2}).value(1,u) = slmeval(weather_data.(field_name{1}).(field_name{2}).unix_time_start(1,u),slm_new);
                end
                
                assignin('base','new_data',new_data);
                assignin('base','weather_data',weather_data);
                
            else
            
            weather_data.(field_name{1}).(field_name{2}).unix_time_end(i)           = weather_data.(field_name{1}).(field_name{2}).unix_time_end(i) - ((factor-1)*(21600/factor));
            weather_data.(field_name{1}).(field_name{2}).interval_time_clear{i}     = {[utc2date(weather_data.(field_name{1}).(field_name{2}).unix_time_start(i)),'-',datestr(utc2date(weather_data.(field_name{1}).(field_name{2}).unix_time_end(i)),13)]};
            
            new_data.(field_name{1}).(field_name{2}).unix_time_end(1)               = new_data.(field_name{1}).(field_name{2}).unix_time_end(1) - ((factor-1)*(21600/factor));
            new_data.(field_name{1}).(field_name{2}).interval_time_clear{1}         = {[utc2date(new_data.(field_name{1}).(field_name{2}).unix_time_start(1)),'-',datestr(utc2date(new_data.(field_name{1}).(field_name{2}).unix_time_end(1)),13)]};

            
               
            for u = i:data_end
                
                weather_data.(field_name{1}).(field_name{2}).unix_time_start(u+1)       = weather_data.(field_name{1}).(field_name{2}).unix_time_start(u) + (21600/factor);
                weather_data.(field_name{1}).(field_name{2}).unix_time_end(u+1)         = weather_data.(field_name{1}).(field_name{2}).unix_time_end(u) + (21600/factor);
                weather_data.(field_name{1}).(field_name{2}).unix_time_record(u+1)      = date2utc(datevec(now));
                weather_data.(field_name{1}).(field_name{2}).interval_time_clear{u+1}   = {[utc2date(weather_data.(field_name{1}).(field_name{2}).unix_time_start(u+1)),'-',datestr(utc2date(weather_data.(field_name{1}).(field_name{2}).unix_time_end(u+1)),13)]};
                
            end
            
            for u = 1:size(new_data.(field_name{1}).(field_name{2}).unix_time_start,2)*factor - 1
                
                new_data.(field_name{1}).(field_name{2}).unix_time_start(u+1)       = new_data.(field_name{1}).(field_name{2}).unix_time_start(u) + (21600/factor);
                new_data.(field_name{1}).(field_name{2}).unix_time_end(u+1)         = new_data.(field_name{1}).(field_name{2}).unix_time_end(u) + (21600/factor);
                new_data.(field_name{1}).(field_name{2}).unix_time_record(u+1)      = date2utc(datevec(now));
                new_data.(field_name{1}).(field_name{2}).interval_time_clear{u+1}   = {[utc2date(new_data.(field_name{1}).(field_name{2}).unix_time_start(u+1)),'-',datestr(utc2date(new_data.(field_name{1}).(field_name{2}).unix_time_end(u+1)),13)]};

            end
            
%             weather_data.(field_name{1}).(field_name{2}).value(1,i:data_end+1) = spline(temp_data_x,temp_data_y,weather_data.(field_name{1}).(field_name{2}).unix_time_start(1,i:end));
            if strcmp(field_name{1},'temperatur') == 1
                slm = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0); 
                slm_new = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
            else
                slm = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','minvalue',min(weather_data.(field_name{1}).(field_name{2}).value(1,i:end)),'leftslope',0,'rightslope',0);
                slm_new = slmengine(temp_data_x,temp_data_y,'plot','off','knots',16,'increasing','off','minvalue',min(new_data.(field_name{1}).(field_name{2}).value(1,1:end)),'leftslope',0,'rightslope',0);
            end
                        
            for u = i:data_end+1
               weather_data.(field_name{1}).(field_name{2}).value(1,u) = slmeval(weather_data.(field_name{1}).(field_name{2}).unix_time_start(1,u),slm); 
            end
            
            for u = 1:size(new_data.(field_name{1}).(field_name{2}).unix_time_start,2)
               new_data.(field_name{1}).(field_name{2}).value(1,u) = slmeval(weather_data.(field_name{1}).(field_name{2}).unix_time_start(1,u),slm_new);
            end
            
            assignin('base','new_data',new_data);
            assignin('base','weather_data',weather_data);
            
            end
            
        end
            
         
    end
    
end

end

