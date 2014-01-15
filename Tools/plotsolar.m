function [ temp ] = plotsolar( datum1, datum2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p=days365(datum1,datum2)+1;
datetest = datum1;
temp = [];
o = 0;
for t = 1:p
    
    [sun_rise_today,sun_set_today] = diurnal_var(48.08, 11.35, datetest);
    [sun_rise_tomorrow,sun_set_tomorrow] = diurnal_var(48.08, 11.35, datestr(datenum(datetest)+1));
    sun_rise_today = double(date2utc(sun_rise_today, 1));
    sun_set_today = double(date2utc(sun_set_today,1));
    sun_rise_tomorrow = double(date2utc(sun_rise_tomorrow,1));
    sun_set_tomorrow = double(date2utc(sun_set_tomorrow,1));
    if t == 1
    temp = [temp, [linspace(sun_rise_today,sun_set_today,4), linspace(sun_rise_tomorrow,sun_set_tomorrow,4)]]; 
    else
    temp = [temp(1:o), [linspace(sun_rise_today,sun_set_today,4), linspace(sun_rise_tomorrow,sun_set_tomorrow,4)]];    
    end
    datetest = datestr(datenum(datum1)+t,1);
    o=o+4;
    
end

end

