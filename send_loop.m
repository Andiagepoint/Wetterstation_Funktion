function [  ] = send_loop(obj, event, t, forecast_definition, device_id )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h = waitbar(0,'Please wait while receiving data...');
for r = 1:t
        
        cycle_number = r;
    
        forecast_interval           = regexp(forecast_definition{r},'-','split');
        start_reg                   = forecast_interval(1,3:4);
        end_reg                     = forecast_interval(1,5:6);

        [ start_reg_address ]       = get_reg_address( forecast_interval{1}, forecast_interval{2}, start_reg );
        [ end_reg_address ]         = get_reg_address( forecast_interval{1}, forecast_interval{2}, end_reg );

        [quantity_reg_addresses]    = reg_num(start_reg_address, end_reg_address);

        [ modbus_pdu ]              = gen_msg( device_id, start_reg_address, quantity_reg_addresses, 'rr' );
        
        [ txdata ]                  = send_and_receive_data(modbus_pdu, forecast_interval, cycle_number);
        
        waitbar(r/t,h)
end

weather_data = evalin('base','weather_data');
if size(weather_data,2) > 6
new_data = evalin('base','new_data');
weather_data(:,size(weather_data,2)-1:size(weather_data,2)) = new_data;
assignin('base','weather_data',weather_data);
end
close(h);
end

