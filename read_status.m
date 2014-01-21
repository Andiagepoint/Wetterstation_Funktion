function [ response ] = read_status( kind_of_status )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
serial_interface = evalin('base','serial_interface');
reg_adr = get_reg_address(kind_of_status);
reg_number = reg_num(reg_adr,reg_adr);
msg = gen_msg('03',reg_adr,reg_number,'rsc');
txdata = format_modbus_msg(msg);
fwrite(serial_interface,txdata);
rxdata = fread(serial_interface,serial_interface.BytesAvailable,'uint8');
response = rxdata_processing(rxdata,txdata,'','','','','');

end

