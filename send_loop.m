function [  ] = send_loop(obj, event, t, forecast_definition, device_id, filepath, update_cycle_number )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h = waitbar(0,'Please wait while receiving data...');
new_data = cell(1,5);
assignin('base','new_data',new_data);
for r = 1:t
        
        cycle_number = r;
    
        forecast_interval           = regexp(forecast_definition{r},'-','split');
        
        forecast_days               = forecast_interval{1,3};
        
        if str2double(forecast_days) > 4 || strcmp(forecast_days,'all') ~= 1
            close(h);
            error(['Das Prognoseintervall wurde falsch eingegeben. ' ...
                   'Es stehen nur die Werte 1,2,3,all zur Verfügung.']);
            
        else
        
        if strcmp(forecast_interval{1,2},'Mittlere_temp_prog') == 1
            switch forecast_days
                case '1'
                   start_reg    = {'Heute' 'AM0_00'};
                   end_reg      = {'Heute' 'PM11_00'};
                case '2'
                   start_reg    = {'Erster_Folgetag' 'AM0_00'}; 
                   end_reg      = {'Erster_Folgetag' 'PM11_00'};
                case '3'
                   start_reg    = {'Zweiter_Folgetag' 'AM0_00'}; 
                   end_reg      = {'Zweiter_Folgetag' 'PM11_00'};
                case '4'
                   start_reg    = {'Dritter_Folgetag' 'AM0_00'}; 
                   end_reg      = {'Dritter_Folgetag' 'PM11_00'};
                case 'all'
                    start_reg   = {'Heute' 'AM0_00'};
                    end_reg     = {'Dritter_Folgetag' 'PM11_00'};
            end
        elseif strcmp(forecast_interval{1,1},'Solarleistung') == 1 || strcmp(forecast_interval{1,1},'Luftdruck') == 1
            if str2double(forecast_days) > 2
                warning(['Für die Solarleistungs- und Luftdruckprognose' ...
                        ' werden nur Werte für den heutigen Tag und den' ...
                        ' ersten Folgetag bereitgestellt.'])
                forecast_days = 'all';    
            end
            switch forecast_days
                case '1'
                   start_reg    = {'Heute' 'Morgen'};
                   end_reg      = {'Heute' 'Abend'};
                case '2'
                   start_reg    = {'Erster_Folgetag' 'Morgen'}; 
                   end_reg      = {'Erster_Folgetag' 'Abend'};
                case 'all'
                   start_reg    = {'Heute' 'Morgen'}; 
                   end_reg      = {'Erster_Folgetag' 'Abend'};
            end 
        else
            switch forecast_days
                case '1'
                   start_reg    = {'Heute' 'Morgen'};
                   end_reg      = {'Heute' 'Abend'};
                case '2'
                   start_reg    = {'Erster_Folgetag' 'Morgen'}; 
                   end_reg      = {'Erster_Folgetag' 'Abend'};
                case '3'
                   start_reg    = {'Zweiter_Folgetag' 'Morgen'}; 
                   end_reg      = {'Zweiter_Folgetag' 'Abend'};
                case '4'
                   start_reg    = {'Dritter_Folgetag' 'Morgen'}; 
                   end_reg      = {'Dritter_Folgetag' 'Abend'};
                case 'all'
                   start_reg    = {'Heute' 'Morgen'}; 
                   end_reg      = {'Dritter_Folgetag' 'Abend'};
            end       
        end
        
%         if size(forecast_interval,2) < 5 
%             end_reg                 = start_reg;
%         else
%             end_reg                 = forecast_interval(1,5:6);
%         end

        forecast_interval           = {forecast_interval{1,1:2}, start_reg{:}, end_reg{:}};

        [ start_reg_address ]       = get_reg_address( forecast_interval{1}, forecast_interval{2}, start_reg );
        [ end_reg_address ]         = get_reg_address( forecast_interval{1}, forecast_interval{2}, end_reg );

        [quantity_reg_addresses]    = reg_num(start_reg_address, end_reg_address);

        [ modbus_pdu ]              = gen_msg( device_id, start_reg_address, quantity_reg_addresses, 'rr' );
        
        [ txdata ]                  = send_and_receive_data(modbus_pdu, forecast_interval, cycle_number);
        
        waitbar(r/t,h)
        end
end

new_data = evalin('base','new_data');
weather_data = evalin('base','weather_data');

if size(weather_data,2) > 9
    weather_data(:,size(weather_data,2)-4:size(weather_data,2)) = new_data(:,4:8);
    assignin('base','weather_data',weather_data);
    filename = strcat(filepath,'\new_data_',date,'_',num2str(date2utc(datevec(now))),'.mat');
    save(filename,'new_data','-mat');
    if ~isempty(update_cycle_number)
        update_cycle_number = evalin('base','update_cycle_number');
        update_cycle_number = update_cycle_number-1;
        fprintf('Noch %u ausstehende Abfrage(n).\n',update_cycle_number)
        assignin('base','update_cycle_number',update_cycle_number);
    end
else
    filename = strcat(filepath,'\new_data_',date,'_',num2str(date2utc(datevec(now))),'.mat');
    new_data = weather_data(:,4:8);
    save(filename,'new_data','-mat');
    if ~isempty(update_cycle_number)
        update_cycle_number = evalin('base','update_cycle_number');
        update_cycle_number = update_cycle_number-1; 
        fprintf('Noch %u ausstehende Abfrage(n).\n',update_cycle_number)
        assignin('base','update_cycle_number',update_cycle_number);
    end
end
close(h);
end

