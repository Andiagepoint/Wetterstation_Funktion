function [  ] = stop_timer(mTimer,~,filepath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('Automatic requests finished.');
delete(mTimer)
filename = strcat(filepath,'\weather_data_',date,'.mat');
weather_data = evalin('base','weather_data');
save(filename,'weather_data','-mat');

end

