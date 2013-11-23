function [ modbus_pdu ] = gen_pdu( device_add, fcode, start_reg, num_reg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
modbus_pdu = strcat(device_add, fcode, start_reg, num_reg);

end

