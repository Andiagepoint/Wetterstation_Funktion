function [ num_reg ] = reg_num( start_address, end_address)
%Calculates the difference between start and end register number
%   Detailed explanation goes here
if hex2dec(start_address) > hex2dec(end_address) 
    error('Bitte überprüfen Sie, ob das Abfrageintervall korrekt ausgewählt wurde! Das Startdatum muss vor dem Enddatum liegen!','Eingabefehler');
else
    num_reg = dec2hex(hex2dec(end_address)-hex2dec(start_address)+1,4);
end
end
