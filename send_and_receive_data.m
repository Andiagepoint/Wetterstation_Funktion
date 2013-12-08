function [ value ] = send_and_receive_data( modbus_msg, field_name, cycle_number )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
serial_interface = evalin('base','serial_interface');

txdata = format_modbus_msg(modbus_msg);

fwrite(serial_interface,txdata);

pause(1);

if serial_interface.BytesAvailable == 0
    bytes_num = 8;
else
    bytes_num = serial_interface.BytesAvailable;
end

[rxdata] = fread(serial_interface, bytes_num, 'uint8');

[value, error_msg] = rxdata_processing( rxdata, modbus_msg, field_name, cycle_number );

end

