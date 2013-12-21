function [  ] = stop_timer(mTimer,~,filepath)
%Deletes timer object, serial interface and saves weather_data container to specified folder
%   Detailed explanation goes here

fprintf(['Automatischer Abruf für den angegebenen Beobachtungszeitraum\n' ...
      'wurde beendet.\n']);
  
delete(mTimer)

filename = strcat(filepath,'\weather_data_',date,'_',num2str(date2utc(datevec(now))),'.mat');
weather_data = evalin('base','weather_data');
save(filename,'weather_data','-mat');

close_serial_port();
evalin('base','clear update_cycle_number');
end

