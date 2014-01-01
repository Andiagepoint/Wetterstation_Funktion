function [ sunrise sunset ] = diurnal_var( latitude, longitude, date_of_day )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
phi_horz = pi/4;
prime_meridian = pi/6;

current_date = regexp(datestr(date_of_day,6),'/','split');
current_month = str2double(current_date(1));
current_day = str2double(current_date(2));

day_num = 30.3*(current_month-1)+current_day;

declination = (23.45/360)*2*pi*sin(2*pi*(284+day_num)/365);

w_s = abs(acos(-tan(declination)*tan(latitude/360*2*pi)));

tlt_sunrise = 12 - w_s/((15/360)*2*pi);
tlt_sunset = 12 + w_s/((15/360)*2*pi);

tequation = 0.123*cos(2*pi*(88+day_num)/365)-0.167*sin(4*pi*(10+day_num)/365);

sunset = tlt_sunset-(tequation+((longitude/360)*2*pi-prime_meridian)/((15/360)*2*pi));
sunrise = tlt_sunrise-(tequation+((longitude/360)*2*pi-prime_meridian)/((15/360)*2*pi));

sunset_hour= floor(sunset);
sunset_dec = sunset-sunset_hour;
sunrise_hour = floor(sunrise);
sunrise_dec = sunrise-sunrise_hour;

sunrise_min = floor(sunrise_dec*60);
sunrise_sec = floor((sunrise_dec*60 - sunrise_min)*60);

sunset_min = floor(sunset_dec*60);
sunset_sec = floor((sunset_dec*60 - sunset_min)*60);

sunrise_vec = [datevec(date_of_day) sunrise_hour sunrise_min sunrise_sec];
sunset_vec = [datevec(date_of_day) sunset_hour sunset_min sunset_sec];

end

