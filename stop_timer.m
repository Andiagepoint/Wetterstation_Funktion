function [  ] = stop_timer(mTimer,~,filepath)
%Deletes timer object, serial interface and saves weather_data container to specified folder
%   Detailed explanation goes here

fprintf(['Automatischer Abruf für den angegebenen Beobachtungszeitraum\n' ...
      'wurde erfolgreich abgeschlossen.\n']);
  
delete(mTimer)

filename = strcat(filepath,'\weather_data_',date,'.mat');
weather_data = evalin('base','weather_data');
save(filename,'weather_data','-mat');

close_serial_port();

end

