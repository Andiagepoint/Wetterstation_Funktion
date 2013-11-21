function [ modbus_pud_msg ] = build_regread_modbus_msg( device_id, reg_address, reg_num )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
func_code = '03';
modbus_pud_msg = strcat(device_id, func_code, reg_address, reg_num);

end

