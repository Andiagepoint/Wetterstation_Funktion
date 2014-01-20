function [  ] = send_loop(obj, event, t, forecast_definition, device_id, filepath, city_name, update_cycle_number, resolution, longitude, latitude )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h = waitbar(0,'Please wait while receiving data...');

daychange_flag = evalin('base','daychange_flag');
daychange_counter = evalin('base','daychange_counter');
w_dat = evalin('base','weather_data');

for r = 1:t
    
        forecast_interval           = regexp(forecast_definition{r},'-','split');
        if r == 1
            
            if ~isempty(w_dat.(forecast_interval{1}).(forecast_interval{2}).unix_t_rec)
                t_rec = w_dat.(forecast_interval{1}).(forecast_interval{2}).unix_t_rec(size(w_dat.(forecast_interval{1}).(forecast_interval{2}).unix_t_rec,2));

                if days365(utc2date(t_rec),date) ~= 0
                    daychange_flag = 1;
                    daychange_counter = daychange_counter + 1;
                else
                    daychange_flag = 0;
                end
            assignin('base','daychange_flag',daychange_flag);
            assignin('base','daychange_counter',daychange_counter);
            end
            
        end
        
        forecast_days               = forecast_interval{1,3};


            if strcmp(forecast_interval{1,2},'mittlere_temp_prog') == 1
                
                switch forecast_days
                    case '1'
                       start_reg    = {'heute' 'am0_00'};
                       end_reg      = {'heute' 'pm11_00'};
                    case '2'
                       start_reg    = {'erster_folgetag' 'am0_00'}; 
                       end_reg      = {'erster_folgetag' 'pm11_00'};
                    case '3'
                       start_reg    = {'zweiter_folgetag' 'am0_00'}; 
                       end_reg      = {'zweiter_folgetag' 'pm11_00'};
                    case '4'
                       start_reg    = {'dritter_folgetag' 'am0_00'}; 
                       end_reg      = {'dritter_folgetag' 'pm11_00'};
                    case 'all'
                        start_reg   = {'heute' 'am0_00'};
                        end_reg     = {'dritter_folgetag' 'pm11_00'};
                end
                
            elseif strcmp(forecast_interval{1,1},'solarleistung') == 1 || strcmp(forecast_interval{1,1},'luftdruck') == 1
                
                if str2double(forecast_days) > 1
                    warning(['Für die Solarleistungs- und Luftdruckprognose' ...
                            ' werden nur Werte für den heutigen Tag und den' ...
                            ' ersten Folgetag bereitgestellt.'])
                    forecast_days = 'all';    
                end
                
                switch forecast_days
                    case '1'
                       start_reg    = {'heute' 'morgen'};
                       end_reg      = {'heute' 'abend'};
                    case 'all'
                       start_reg    = {'heute' 'morgen'}; 
                       end_reg      = {'erster_folgetag' 'abend'};
                end
                
            else
                
                switch forecast_days
                    case '1'
                       start_reg    = {'heute' 'morgen'};
                       end_reg      = {'heute' 'abend'};
                    case '2'
                       start_reg    = {'heute' 'morgen'}; 
                       end_reg      = {'erster_folgetag' 'abend'};
                    case '3'
                       start_reg    = {'heute' 'morgen'}; 
                       end_reg      = {'zweiter_folgetag' 'abend'};
                    case 'all'
                       start_reg    = {'heute' 'morgen'}; 
                       end_reg      = {'dritter_folgetag' 'abend'};
                end 
                
            end

%         if size(forecast_interval,2) < 5 
%             end_reg                 = start_reg;
%         else
%             end_reg                 = forecast_interval(1,5:6);
%         end

        forecast_interval           = {forecast_interval{1,1:2}, start_reg{:}, end_reg{:}};

        start_reg_address           = get_reg_address( forecast_interval{1}, forecast_interval{2}, start_reg );
        end_reg_address             = get_reg_address( forecast_interval{1}, forecast_interval{2}, end_reg );

        quantity_reg_addresses      = reg_num(start_reg_address, end_reg_address);

        modbus_pdu                  = gen_msg( device_id, start_reg_address, quantity_reg_addresses, 'rsr' );
        
        con_qual                    = read_com_set('03',{'quality'});

        txdata                      = send_and_receive_data(modbus_pdu, forecast_interval, resolution, con_qual, longitude, latitude);

        waitbar(r/t,h)
            
        
end

new_data = evalin('base','new_data');

filename = strcat(filepath,'\',city_name,'-',strrep(num2str(resolution),'.','_'),'_new_data_',date,'_',num2str(date2utc(datevec(now))),'.mat');
save(filename,'new_data','-mat');

new_data = [];

for z = 1:t
    new_data = create_data_struct(forecast_definition{z}, new_data, 'new_data');
end

assignin('base','new_data',new_data);

if ~isempty(update_cycle_number)
    update_cycle_number = evalin('base','update_cycle_number');
    update_cycle_number = update_cycle_number-1;
    fprintf('Noch %u ausstehende Abfrage(n).\n',update_cycle_number)
    assignin('base','update_cycle_number',update_cycle_number);
end



close(h);
end

