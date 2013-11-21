function [ num_reg ] = input_check( start_address, end_address, func_code, device )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if hex2dec(start_address) > hex2dec(end_address) 
    errordlg('Bitte überprüfen Sie, ob das Abfrageintervall korrekt ausgewählt wurde! Das Startdatum muss vor dem Enddatum liegen!','Eingabefehler');
else
    num_reg = dec2hex(hex2dec(end_address)-hex2dec(start_address)+1,4);
end
if strcmp(func_code,'00') == 1 || isempty(func_code) == 1
    errordlg('Bitte wählen Sie den gewünschten Funktionscode aus!','Unvollständige Eingabe');
end
if strcmp(device, '00') == 1 || isempty(device) == 1
    errordlg('Bitte wählen Sie eine gültige Device-Addresse aus!', 'Unvollständige Eingabe');
end
end

