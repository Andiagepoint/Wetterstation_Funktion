function [ dec_value ] = data_proc( value, reg_address, field_name, cycle_number )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
data = evalin('base','data');

weather_data = evalin('base','weather_data');

if cycle_number == 1
    size_weather_data_r = 1;
    size_new_data_r = 1;
    weather_data{1,size(weather_data,2)+2} = [];
    size_weather_data_c = size(weather_data,2);
    new_data = cell(1,2);
else
    new_data = evalin('base','new_data');
    size_weather_data_r = size(weather_data,1);
    size_new_data_r = size(new_data,1);
end

days = {'Heute' 'Erster_Folgetag' 'Zweiter_Folgetag' 'Dritter_Folgetag'};
hours_rough = {'Morgen' 'Vormittag' 'Nachmittag' 'Abend'};
hours_detailed = {'AM0_00' 'AM01_00' 'AM02_00' 'AM03_00' 'AM04_00' 'AM05_00' 'AM06_00' ...
         'AM07_00' 'AM08_00' 'AM09_00' 'AM10_00' 'AM11_00' 'AM12_00' 'PM01_00' 'PM02_00' 'PM03_00' 'PM04_00' 'PM05_00' 'PM06_00' 'PM07_00' ...
         'PM08_00' 'PM09_00' 'PM10_00' 'PM11_00'};
com_settings = {'temperature_offset','temperature','city_id','transmitting_station','quality','fsk_qualitaet' 'status_ext_temp_sensor' 'reserve1' 'reserve2' 'reserve3'};

if strcmp('data.Communication_Settings',field_name) == 1
    dec_value = hex2dec(strcat(dec2hex(value(1),2),dec2hex(value(2),2)));
    if dec_value > 32768
        dec_value = dec_value - 65536;
    end
else
    start = regexp(field_name{3},'-','split');
    if strcmp(field_name{2},'Mittlere_temp_prog')==1
        [true, sdindex] = ismember(start{1}, days);
    else
        [true, sdindex] = ismember(start{1}, days);
    end
    
    if size(field_name,2) < 4
        % Here only one value will be requested, so the for loops have to
        % be run only once
        edindex = sdindex;
    else
        ende = regexp(field_name{4},'-','split');
        if strcmp(field_name{2},'Mittlere_temp_prog')==1
            [true, edindex] = ismember(ende{1}, days);
        else
            [true, edindex] = ismember(ende{1}, days);
        end
    end
    
    lfvara = 1;
    lfvare = 2;
    
    for t = sdindex:edindex
       
        if t == sdindex
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    [true, shindex] = ismember(start{2}, hours_detailed);
                else
                    [true, shindex] = ismember(start{2}, hours_rough);
                end
                if size(field_name,2) < 4
                    ehindex = shindex;
                elseif strcmp(field_name{2},'Mittlere_temp_prog')==1
                    ehindex = 24;
                else
                    ehindex = 4;
                end
        elseif t == edindex
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    [true, ehindex] = ismember(ende{2}, hours_detailed);
                else
                    [true, ehindex] = ismember(ende{2}, hours_rough);
                end
                shindex = 1;
        else
                shindex = 1;
                if strcmp(field_name{2},'Mittlere_temp_prog')==1
                    ehindex = 24;
                else
                    ehindex = 4;
                end
        end
        
        for s = shindex:ehindex

            if lfvare > size(value,1)
                break;
            end
            hi_byte = dec2hex(value(lfvara),2);
            lo_byte = dec2hex(value(lfvare),2);
            hex_value = strcat(hi_byte,lo_byte);
            dec_value = hex2dec(hex_value);
            
            if dec_value > 32768
                dec_value = dec_value - 65536;
            end
            
%             if  size(weather_data,2) < 7
%                 weather_data_col_utc = 5;
%                 weather_data_col_data = 6;
%             else
%                 weather_data_col_utc = size(weather_data,2) - 1;
%                 weather_data_col_data = size(weather_data,2);
%             end
            
            if strcmp(field_name{2},'Mittlere_temp_prog')==1
                fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, days{t}, hours_detailed{s}, date2utc(datevec(now)), dec_value)
                if size(weather_data,2) < 7
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    weather_data{size_weather_data_r,3} = days{t};
                    weather_data{size_weather_data_r,4} = hours_detailed{s};
                    weather_data{size_weather_data_r,5} = date2utc(datevec(now));
                    weather_data{size_weather_data_r,6} = dec_value;
                else
                    new_data{size_new_data_r,1} = date2utc(datevec(now));
                    new_data{size_new_data_r,2} = dec_value;          
                end
            else
                fprintf('%s %s %s - %s, %u %u \n', field_name{1}, field_name{2}, days{t}, hours_rough{s}, date2utc(datevec(now)), dec_value)
                if size(weather_data,2) < 7
                    weather_data{size_weather_data_r,1} = field_name{1};
                    weather_data{size_weather_data_r,2} = field_name{2};
                    weather_data{size_weather_data_r,3} = days{t};
                    weather_data{size_weather_data_r,4} = hours_rough{s};
                    weather_data{size_weather_data_r,5} = date2utc(datevec(now));
                    weather_data{size_weather_data_r,6} = dec_value;
                else
                    new_data{size_new_data_r,1} = date2utc(datevec(now));
                    new_data{size_new_data_r,2} = dec_value;
                end
            end

            lfvara = lfvara + 2;
            lfvare = lfvare + 2;
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

