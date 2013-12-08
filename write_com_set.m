function [ ] = write_com_set( device_id, request_value_list, reg_add_list )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fcode_ws_reg                = '06';

wb                          = waitbar(0,'Please wait while writing to registers ...');

request_value_list          = dec2hex(request_value_list,4);
waitbar(1/3,wb)    
[reg_add, field_name]       = get_reg_address(char(reg_add_list));

modbus_msg                  = strcat(device_id, fcode_ws_reg, reg_add, request_value_list);
waitbar(2/3,wb)
msg                         = crc_calc(char(modbus_msg));

[rxdata]                    = send_and_receive_data(msg, field_name, '');
waitbar(3/3,wb)
close(wb)

end

