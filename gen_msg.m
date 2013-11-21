function [ modbus_msg ] = gen_msg( device_id, reg_address, reg_num, type )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch type
    case 'rr'
    fcode = '03';
    case 'srw'
    fcode = '06';    
    case 'cr'
    fcode = '01';    
    case 'scw'
    fcode = '05';    
    otherwise
end
    modbus_pud_msg = strcat(device_id, fcode, reg_address, reg_num);
    modbus_msg = crc_calc(modbus_pud_msg);
end

