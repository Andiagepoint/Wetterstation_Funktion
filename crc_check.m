function [ check, response_msg ] = crc_check( rxdata )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
msg = '';
for t = 1:(size(rxdata,1)-2)
hex_val = dec2hex(rxdata(t),2);
msg = strcat(msg,hex_val);
end
crc_checksum = strcat(dec2hex(rxdata(end-1,1),2),dec2hex(rxdata(end,1),2));
response_msg = crc_calc(msg);
if strcmp(response_msg(end-3:end),crc_checksum) == 1 
    check = 1;
else
    check = 0;
end
end

