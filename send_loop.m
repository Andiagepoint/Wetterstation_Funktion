function [  ] = send_loop(obj, event, t, table_data, hObject, handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h = waitbar(0,'Please wait while receiving data...');
for r = 1:t
        
        cycle_number = r;
    
        if table_data{r,6} == 1
        msg = table_data{r,5};
        field_name = {table_data{r,1} table_data{r,2} table_data{r,3} table_data{r,4}};
        [ txdata ] = send_and_receive_data(msg, field_name, hObject, handles, cycle_number);
        end
        
        waitbar(r/t,h)
end

weather_data = evalin('base','weather_data');
if size(weather_data,2) > 6
new_data = evalin('base','new_data');
weather_data(:,size(weather_data,2)-1:size(weather_data,2)) = new_data;
assignin('base','weather_data',weather_data);
end
close(h);
end

