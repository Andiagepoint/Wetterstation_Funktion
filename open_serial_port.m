function [ ] = open_serial_port( com_address, baudrate, databits, parity, stopbit )
%This function establishes the modbus communication channel
%   Detailed explanation goes here
% if size(com_address,2) < 4
%     errordlg('Bitte geben Sie eine g�ltige Com-Addresse ein!', 'Falscher Com-Port');
% elseif isnan(baudrate)
%     errordlg('Bitte w�hlen Sie eine g�ltige Baudrate aus!', 'Falsche Baudrate');
% elseif isempty(databits)
%     errordlg('Bitte geben Sie g�ltige Databits ein!', 'Falsche Databits');
% elseif isempty(parity)
%     errordlg('Bitte w�hlen Sie ein g�ltiges Parity aus!', 'Falsche Parity');
% elseif isempty(stopbit)
%     errordlg('Bitte geben Sie ein g�ltiges Stop-Bit ein', 'Falsches Stopbit');
% end
serial_interface = serial(com_address,'BaudRate',baudrate,'DataBits',databits,'Parity',parity,'StopBits',stopbit);
assignin('base','serial_interface',serial_interface);
fopen(serial_interface);
sprintf('%s','Modbus communication established as "serial_interface"')
end

