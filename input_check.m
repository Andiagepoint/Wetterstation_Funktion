function [ num_reg ] = input_check( start_address, end_address, func_code, device )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if hex2dec(start_address) > hex2dec(end_address) 
    errordlg('Bitte �berpr�fen Sie, ob das Abfrageintervall korrekt ausgew�hlt wurde! Das Startdatum muss vor dem Enddatum liegen!','Eingabefehler');
else
    num_reg = dec2hex(hex2dec(end_address)-hex2dec(start_address)+1,4);
end
if strcmp(func_code,'00') == 1 || isempty(func_code) == 1
    errordlg('Bitte w�hlen Sie den gew�nschten Funktionscode aus!','Unvollst�ndige Eingabe');
end
if strcmp(device, '00') == 1 || isempty(device) == 1
    errordlg('Bitte w�hlen Sie eine g�ltige Device-Addresse aus!', 'Unvollst�ndige Eingabe');
end
end

