function [  ] = serial_interface_check(  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% Error when no serial interface is established
if evalin('base','exist(''serial_interface'')') == 0
    error('No modbus connection established! Please connect to serial interface!');
end

end

