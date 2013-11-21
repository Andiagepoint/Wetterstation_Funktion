function [ output_args ] = write_sr( request_value_list, reg_add_list, hObject, handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fcode_ws_reg = '06';

data = evalin('base','data');

wb = waitbar(0,'Please wait while writing to registers ...');
            
for t = 1:size(reg_add_list,2)
    waitbar(t/size(reg_add_list,2))
    [reg_add, field_name] = get_reg_address(char(reg_add_list(t)));
    modbus_msg = strcat(request_value_list(4), fcode_ws_reg, reg_add, request_value_list(t));
    msg = crc_calc(char(modbus_msg));
    [rxdata] = send_and_receive_data(msg, field_name, hObject, handles);
end
    
close(wb)

end

