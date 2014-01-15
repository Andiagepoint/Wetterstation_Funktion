function [ output_args ] = dpsim( data_string, prg_def, resolution, res_old, con_qual )
% Processes the rxdata and allocates it to the data container in a defined
% structure
%   Detailed explanation goes here


% Get the register data and weather data container form the base workspace

% register_data_hwk_kompakt = evalin('base','register_data_hwk_kompakt');

w_dat = evalin('base','weather_data');
n_dat = evalin('base','new_data');
timestamp = evalin('base','timestamp');
daychange_flag = evalin('base','daychange_flag');
daychange_counter = evalin('base','daychange_counter');
prg_def              = regexp(prg_def,'-','split');

% Decide if MEZ or MESZ is valid

MEZ = MESZ_calc();

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

if strcmp('register_data_hwk_kompakt.communication_settings',prg_def) == 1
    dec_value = hex2dec(strcat(dec2hex(data_string(1),2),dec2hex(data_string(2),2)));
    
    % As we have an unsigned value from the message, we have to convert
    % it to a signed value, which means FFFF or 65535 stands for -1
    
    if dec_value > 32768
        dec_value = dec_value - 65536;
    end
    
else
    
% Initialize variables for data position    
    t_rec = [];
    i           = 1;
    n_dat_r  = 1;
    o=1;
    
% Decide which factor to choose 

    factor = res_factor(resolution,prg_def{2});
    
% When the first function call was executed a record timestamp will be 
% stored in the data container. The last record date of the last update 
% will be assigned to t_rec to compare it with the current update date to
% evaluate if a daychange has been occured.

    if ~isempty(w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec)
        t_rec = w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(size(w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec,2));
    end
       
% sdindex = starting point of the loop through the observation days
% edindex = end point 
    
    [~, sdindex] = ismember(prg_def{3}, obs_day);

% If condition is true only one day will be observed, the loop for
% observation days will be run only once.      
    if size(prg_def,2) < 5
        
        edindex = sdindex;
        
    else
        
% If condition is false, number of loops will be determined by the list
% position (obs_day) of the last day of observation.        
        [~, edindex] = ismember(prg_def{5}, obs_day);
        
    end
    
    
% When the function is called the first time t_rec will be empty and the
% start position for the interpolated and original data datavector will 
% be 1.
    
    if isempty(t_rec)
        
        w_dat_r = 1;
        w_dat_r_org = 1;
         
    else
        
        datetest = datestr(utc2date(timestamp),1);
        now_s =  datenum(utc2date(timestamp));
        
% If t_rec is not empty a previous function call had been executed. If this
% execution was on the same day data vector position has to stay constant.
% In the case a daychange occures daychange will be increased by 1.  
        
        if strcmp(prg_def{1},'luftdruck') == 1
            if days365(utc2date(t_rec),datetest) ~= 0
                daychange_flag = 1;
                daychange_counter = daychange_counter + 1;
            else
                daychange_flag = 0;
            end
        assignin('base','daychange_flag',daychange_flag);
        assignin('base','daychange_counter',daychange_counter);
        end
        
% Get the data vector position for which the date changes, start at positon
% 1 from recording.

        while strcmp(datestr(utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i)),1),datetest) ~= 1
            i = i + 1;
            if i > size(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)
                break;
            end
        end
        
% i will be the next position in the data vector to write data to            
        w_dat_r = i;
        
% For the data with no interpolation you don´t have to change position
% cause they go parallel.

            if strcmp(prg_def{1},'markantes_wetter') == 1 || strcmp(prg_def{1},'signifikantes_wetter') == 1 || strcmp(prg_def{2},'richtung') == 1 || strcmp(prg_def{2},'wahrscheinlichkeit') == 1
                w_dat_r_org = w_dat_r;
            else
                
% For interpolated data you have to make a difference between original data
% and interpolated data vector position. 
                if size(w_dat.(prg_def{1}).(prg_def{2}).int_val,2) == 8 
                    w_dat_r_org = i;
                elseif size(w_dat.(prg_def{1}).(prg_def{2}).int_val,2) == 16
                    w_dat_r_org = i;
                elseif size(w_dat.(prg_def{1}).(prg_def{2}).int_val,2) == 96
                    w_dat_r_org = i;
                else
                    if strcmp(prg_def{2},'mittlere_temp_prog') == 1 
                        w_dat_r_org = 24*daychange_counter+1;
                    else
                        w_dat_r_org = 4*daychange_counter+1;
                    end
                end 
                
            end
    end
    
% Interpolation start variable

w_dat_r_org_ni = w_dat_r_org;
    
% Increment initialization for the data loop
    
    data_str_hi_byte_pos = 1;
    data_str_lo_byte_pos = 2;
    
% Loop through response data
    
    for t = sdindex:edindex
       
% With the first day of observation, determine the starting point
% of the observation day segment or point in time
% (Mittlere_temp_prog)
        
        if t == sdindex
                
% Determine starting point for the first observation day
                if strcmp(prg_def{2},'mittlere_temp_prog') == 1
                    
                    [~, shindex] = ismember(prg_def{4}, point_in_time);
                    
                else
                    
                    [~, shindex] = ismember(prg_def{4}, day_segment);
                    
                end
                
% End point for the first observation day will either be
% the starting point, when only one value is requested, or
% the entire intervall (24,4), which will be stopped at when
% the data string is completely evaluated.
                
                if size(prg_def,2) < 5
                    
                    ehindex      = shindex;
                    
                elseif strcmp(prg_def{2},'mittlere_temp_prog') == 1
                    
                    ehindex      = 24;
                    
                else
                    
                    ehindex      = 4;
                    
                end
                
        elseif t == edindex
                
% If more then one day is observed we have in any case at
% least a starting index of 1. The ending point is
% determined through the list position in point_in_time or
% day_segment.
                
                shindex          = 1;
                
                if strcmp(prg_def{2},'mittlere_temp_prog') == 1
                    
                    [~, ehindex] = ismember(prg_def{6}, point_in_time);
                    
                else
                    
                    [~, ehindex] = ismember(prg_def{6}, day_segment);
                    
                end
                
        else
            
% If the observation intervall exceeds more than two days,
% the starting point and end point are defined over the
% complete forecast intervall for the days between start
% and end day. 
            
                shindex        = 1;
                
                if strcmp(prg_def{2},'mittlere_temp_prog') == 1
                    
                    ehindex    = 24;
                    
                else
                    
                    ehindex    = 4;
                    
                end
                
        end
        
        if t == sdindex
                datepart       = str2double(regexp(datestr(datetest,'yyyy-mm-dd'),'-','split'));
                date_str_num   = datenum(datetest);
        else 
                datepart       = datepart + [0 0 1];
                date_str_num   = date_str_num + 1;
        end
        
        for s = shindex:ehindex

% Break condition for an completely evaluated data string
            
%             if data_str_lo_byte_pos > size(data_string,2)
%                 
%                 break;
%                 
%             end
            
            % Evaluation of a 16-bit word, big-Endian
            
%             hi_byte        = dec2hex(data_string(data_str_hi_byte_pos),2);
%             lo_byte        = dec2hex(data_string(data_str_lo_byte_pos),2);
%             hex_value      = strcat(hi_byte,lo_byte);
%             dec_value      = hex2dec(hex_value);
            dec_value      = data_string(o);
            
% Receiving uint bytes, signed bytes will be calculated here
            
            if dec_value > 32768
                dec_value  = dec_value - 65536;
            end
            
% Set the unix timestamp to the original interval the data are valid for.
            if s > 4
                timevec = tvector(prg_def{2}, datepart, point_in_time{s});
            else
                timevec = tvector(prg_def{2}, datepart, point_in_time{s}, day_segment{s});
            end
            
% If any value received is equal to 10000 the data processing for this 
% forecast scope will be canceled.

            if dec_value == 10000
                return;
            end
            
% Determine the offset values for interval timestamps in the case a 
% different resolution then the original resolution was selected.

            if strcmp(prg_def{2},'mittlere_temp_prog') == 1 && factor ~= 6
                timestep = 3600-1;
                timestep_corr = (factor-1)*(3600/factor);
                timestep_int = 3600/factor;
            else
                timestep = 6*3600-1;
                timestep_corr = (factor-1)*(21600/factor);
                timestep_int = 21600/factor;
            end
            
% Assign received value to continous data container. No interpolation is done.             
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(w_dat_r)    = date2utc(timevec);
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(w_dat_r)     = date2utc(timevec) + timestep;
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(w_dat_r)    = date2utc(timevec) + floor(timestep/2);
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(w_dat_r)     = date2utc(datevec(now_s));
                
                w_dat.(prg_def{1}).(prg_def{2}).interval_t_clr{w_dat_r} = {[cell2mat(utc2date(date2utc(timevec))),'-',datestr(utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(w_dat_r)),13)]};

                w_dat.(prg_def{1}).(prg_def{2}).int_val(w_dat_r)            = dec_value;
                w_dat.(prg_def{1}).(prg_def{2}).org_val(w_dat_r_org)        = dec_value;
                w_dat.(prg_def{1}).(prg_def{2}).con_qual(w_dat_r_org)       = con_qual;
               
                
                fprintf('%s %s - %u %u %u %s %u \n', prg_def{1}, prg_def{2}, date2utc(timevec), date2utc(timevec) + timestep, date2utc(datevec(now_s)), cell2mat(strcat(utc2date(date2utc(timevec)),'-',datestr(utc2date(date2utc(timevec) + timestep),13))), data_mult(dec_value,prg_def{2}));                     

% Assign received value to update data container. No interpolation is done.
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(n_dat_r)    = date2utc(timevec);
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(n_dat_r)     = date2utc(timevec) + timestep;
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(n_dat_r)     = date2utc(datevec(now_s));
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(n_dat_r)    = date2utc(timevec) + floor(timestep/2);
                
                n_dat.(prg_def{1}).(prg_def{2}).interval_t_clr{n_dat_r} = {[cell2mat(utc2date(date2utc(timevec))),'-',datestr(utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(n_dat_r)),13)]};

                n_dat.(prg_def{1}).(prg_def{2}).int_val(n_dat_r)        = dec_value;
                n_dat.(prg_def{1}).(prg_def{2}).org_val(n_dat_r)        = dec_value;
                n_dat.(prg_def{1}).(prg_def{2}).con_qual(n_dat_r)       = con_qual;
                   
% Incrementing data string, and data container vector position.
            
            data_str_hi_byte_pos = data_str_hi_byte_pos + 2;
            data_str_lo_byte_pos = data_str_lo_byte_pos + 2;
            
            w_dat_r     = w_dat_r + 1;
            n_dat_r     = n_dat_r + 1;
            w_dat_r_org = w_dat_r_org + 1;
            o=o+1;
            
        end
    end
    
% INTERPOLATION
    
    if resolution == 6

% Assign data container to base workspace no interpolation is done.
    
        assignin('base','new_data',n_dat);
        assignin('base','weather_data',w_dat);
    
    else

% For those forecast scopes with no interpolation the data can be assigned
% to the base workspace.

        if strcmp(prg_def{1},'markantes_wetter') == 1 || strcmp(prg_def{1},'signifikantes_wetter') == 1 || strcmp(prg_def{2},'richtung') == 1 || strcmp(prg_def{2},'wahrscheinlichkeit') == 1
            
            assignin('base','new_data',n_dat);
            assignin('base','weather_data',w_dat);
            
        else
            
% Select x and y values for interpolation from new data
                
            tmp_dat_y = double(n_dat.(prg_def{1}).(prg_def{2}).int_val(1,1:end));
            
            if strcmp(prg_def{1},'solarleistung') == 1
                [sun_rise_today,sun_set_today] = diurnal_var(48.08, 11.35, datetest);
                [sun_rise_tomorrow,sun_set_tomorrow] = diurnal_var(48.08, 11.35, datestr(datenum(datetest)+1));
                sun_rise_today = double(date2utc(sun_rise_today, MEZ));
                sun_set_today = double(date2utc(sun_set_today,MEZ));
                sun_rise_tomorrow = double(date2utc(sun_rise_tomorrow,MEZ));
                sun_set_tomorrow = double(date2utc(sun_set_tomorrow,MEZ));
                tmp_dat_x = [linspace(sun_rise_today,sun_set_today,4), linspace(sun_rise_tomorrow,sun_set_tomorrow,4)];
            else
                tmp_dat_x = double(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,1:end));
            end
            
% If factor is 6 no interval correction has to be done            
            if strcmp(prg_def{2},'mittlere_temp_prog') == 1 && factor == 6
                
% In the case of first function call, data end vector will be the size of 
% data in container - 1. Else you have to add the number of
% interpolated values to i-1 which is the last value not to be overwritten.  

                if i == 1
                
                    data_end = size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2) - 1;
                
                else
                
                    if strcmp(prg_def{2},'mittlere_temp_prog') == 1
                        data_end = i - 1 + edindex*24*factor;
                    else
                        data_end = i - 1 + edindex*4*factor;
                    end
                
                end

% Calculate the interpolation values                
                
                if i == 1
                    slm = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                else
                    
% A previous function call created interpolated values, take the last one
% of these with the new data and interpolate. 

                    slm = slmengine([w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-1) tmp_dat_x],[w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) tmp_dat_y],'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                    
                end
                
                slm_new = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                
% Evaluate interpolation function at timestamps, which are the mean of
% start and end interval. 

%                 for u = i:data_end
                   w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i:data_end) = slmeval(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i:data_end),slm); 
%                 end

%                 for u = 1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)
                   n_dat.(prg_def{1}).(prg_def{2}).int_val(1,1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)) = slmeval(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)),slm_new);
%                 end
                
                assignin('base','new_data',n_dat);
                assignin('base','weather_data',w_dat);
                
            else

% Define the end of datavector after interpolation. Take actual size of new
% data i.e. 8 values for 2 days and multiply it with factor will be the
% same as to divide 48h into 5m intervals. 6h have 72 5m intervals. If
% there has been already a interpolation end of data vector will start from
% the new date which was determined in i.
                if i == 1

                    data_end = size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)*factor;

                else
                    
                    if strcmp(prg_def{2},'mittlere_temp_prog') == 1
                        data_end = i - 1 + edindex*24*factor;
                    else
                        data_end = i - 1 + edindex*4*factor;
                    end

                end    
            
% Adjust start intervals to new resolution  

% Take first interval of daychange 0-6:00 subtract correction to yield
% 0-0:05 for a resolution of 5 Min.. Do this for all intervals. To obtain
% the new interval end of continous data, take the first 6h interval of new
% data and subtract timestep_corr. E.g. resolution is 5m -> new end of
% continous data will be 6h-5h55m.
                
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i)           = n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1) - timestep_corr;
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i)          = floor((w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i)-n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1))/2)+n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1);
               
                w_dat.(prg_def{1}).(prg_def{2}).interval_t_clr(i)       = {[cell2mat(utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1))),'-',datestr(utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i)),13)]};

                n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1)           = n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1) - timestep_corr;
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1)          = floor((n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1)-n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1))/2)+n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1);
                
                n_dat.(prg_def{1}).(prg_def{2}).interval_t_clr{1}       = {[cell2mat(utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1))),'-',datestr(utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1)),13)]};

% Adjust all following intervals 

%                 if daychange_flag == 1
                    
% Start intervall will be starting from 0:00-6:00-timest

                w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i):timestep_int:(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(end)+timestep_corr);
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i):timestep_int:n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(end);
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i):timestep_int:(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(end)+(timestep_corr/2));
                w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(i:data_end)    = date2utc(datevec(now_s));
                
                date_string1 = utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:data_end));
                date_string2 = utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i:data_end));
                w_dat.(prg_def{1}).(prg_def{2}).interval_t_clr(i:data_end) = cellstr(strcat(cell2mat(date_string1'),'-',datestr(cell2mat(date_string2'),13)))';
                
%                 else
%                 
%                 w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i):timestep_int:(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(end));
%                 w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i):timestep_int:w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(end);
%                 w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i:data_end)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i):timestep_int:(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(end));
%                 w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(i:data_end)    = date2utc(datevec(now_s));
%                 
%                 date_string1 = utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:data_end));
%                 date_string2 = utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(i:data_end));
%                 w_dat.(prg_def{1}).(prg_def{2}).interval_t_clr(i:data_end) = cellstr(strcat(cell2mat(date_string1'),'-',datestr(cell2mat(date_string2'),13)))';
%                 w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(i:data_end)    = date2utc(datevec(now_s));
%                 
%                 end
                
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_rec,2)*factor)    = date2utc(datevec(now_s));
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)*factor)    = n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1):timestep_int:(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(end)+timestep_corr);
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_end,2)*factor)    = n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1):timestep_int:n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(end);
                n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)*factor)    = n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1):timestep_int:(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(end)+(timestep_corr/2));
                
                date_string1 = utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)));
                date_string2 = utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)));
                n_dat.(prg_def{1}).(prg_def{2}).interval_t_clr(1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)) = cellstr(strcat(cell2mat(date_string1'),'-',datestr(cell2mat(date_string2'),13)))';
                    
                    
                    
%                 for u = i:data_end-1
% 
%                     w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u+1)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u) + timestep_int;
%                     w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u+1)     = w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u) + timestep_int;
%                     w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(u+1)    = w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(u) + timestep_int;
%                     w_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(u+1)     = date2utc(datevec(now_s));
%                     w_dat.(prg_def{1}).(prg_def{2}).interval_t_clr{u+1} = {[utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u+1)),'-',datestr(utc2date(w_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u+1)),13)]};
% 
%                 end
% 
%                 for u = 1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt,2)*factor - 1
% 
%                     n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u+1)    = n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u) + timestep_int;
%                     n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u+1)     = n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u) + timestep_int;
%                     n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(u+1)    = n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(u) + timestep_int;
%                     n_dat.(prg_def{1}).(prg_def{2}).unix_t_rec(u+1)     = date2utc(datevec(now_s));
%                     n_dat.(prg_def{1}).(prg_def{2}).interval_t_clr{u+1} = {[utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(u+1)),'-',datestr(utc2date(n_dat.(prg_def{1}).(prg_def{2}).unix_t_end(u+1)),13)]};
% 
%                 end
            
% Perform the slm interpolation for temperatur, staerke and luftdruck                
                
                if strcmp(prg_def{1},'temperatur') == 1 || strcmp(prg_def{2},'staerke') == 1 || strcmp(prg_def{1},'luftdruck') == 1 || strcmp(prg_def{1},'solarleistung') == 1
                    
%                     if i == 1
%                         yi = spline(tmp_dat_x,tmp_dat_y,w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:end));
%                     else
%                         yi = spline([w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1,i-1) tmp_dat_x],[w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) tmp_dat_y],w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i-1:end));   
%                     end
%                     yi_new = spline(tmp_dat_x,tmp_dat_y,w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(i:end));
                    
                    if i == 1
                        slm = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                        
                        w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i:data_end) = slmeval(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i:data_end),slm);  
                        
                    else
                        
% Calculate the slope of the end of previous data. The slope of the new 
% calculated interpolation values has to be on the left side equal to that
% of the intersecting old data on the right side. Furthermore the values of 
% old and new data have to be the same.
                        
                        dy = w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) - w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-2);
                        dx = w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-1) - w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-2);
                        m = dy/dx;                        
                        slm = slmengine([w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-1) tmp_dat_x],[w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) tmp_dat_y],'plot','off','knots',16,'increasing','off','leftvalue',w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1),'leftslope',m,'rightslope',0);                         

% Evaluate spline function at timestamps.

%                         for u = i-1:data_end+1
%                             if isnan(slmeval(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,u),slm))
%                                 error('NaN detected');
%                             end
                            w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1:data_end) = slmeval(w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-1:data_end),slm);                           
                            if strcmp(prg_def{1},'solarleistung') == 1
                            temp = w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1:data_end);
                            temp(temp < 0) = 0;
                            w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1:data_end) = temp;
                            end
%                         end
                    end
                    
                    slm_new = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','leftslope',0,'rightslope',0);
                    
%                     for u = 1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)                        
                        n_dat.(prg_def{1}).(prg_def{2}).int_val(1,1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)) = slmeval(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)),slm_new);                        
%                     end
                    
                else

% For the forecast scope solarleistung                     
                    
                    if i == 1
                        yi = spline(tmp_dat_x,tmp_dat_y,w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i:end));
                        yi(yi < 0) = 0;
%                         for w = i:size(yi,2)
%                            if yi(w) < 0
%                                yi(w) = 0;
%                            end
%                         end
                        w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i:(data_end)) = yi; 
                    else
                        yi = spline([w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(1,i-1) tmp_dat_x],[w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) tmp_dat_y],w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i-1:end));
                        yi(yi < 0) = 0;
%                         for w = 1:size(yi,2)
%                            if yi(w) < 0
%                                yi(w) = 0;                               
%                            end
%                         end
                        w_dat.(prg_def{1}).(prg_def{2}).int_val(1,(i-1):(data_end)) = yi;
                    end
                    yi_new = spline(tmp_dat_x,tmp_dat_y,w_dat.(prg_def{1}).(prg_def{2}).unix_t_mean(i:end));
                    yi_new(yi_new < 0) = 0;
%                     for w = 1:size(yi_new,2)
%                        if yi_new(w) < 0
%                            yi_new(w) = 0;
%                        end
%                     end
                    n_dat.(prg_def{1}).(prg_def{2}).int_val(1,1:size(n_dat.(prg_def{1}).(prg_def{2}).unix_t_mean,2)) = yi_new;
                        
%                     if i == 1
%                         slm = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','minvalue',min(w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i:end)),'leftslope',0,'rightslope',0);
%                     else
%                         dy = w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) - w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-2);
%                         dx = w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1,i-1) - w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1,i-2);
%                         m = dy/dx;
%                         slm = slmengine([w_dat.(prg_def{1}).(prg_def{2}).unix_t_strt(1,i-1) tmp_dat_x],[w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-1) tmp_dat_y],'plot','off','knots',16,'increasing','off','minvalue',min(w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i:end)),'leftvalue',w_dat.(prg_def{1}).(prg_def{2}).int_val(1,i-2),'leftslope',m,'rightslope',0);    
%                     end
%                     slm_new = slmengine(tmp_dat_x,tmp_dat_y,'plot','off','knots',16,'increasing','off','minvalue',min(n_dat.(prg_def{1}).(prg_def{2}).int_val(1,1:end)),'leftslope',0,'rightslope',0);
                end

                assignin('base','new_data',n_dat);
                assignin('base','weather_data',w_dat);
            
            end
            
        end
            
         
    end


end

end

