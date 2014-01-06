function [ date_str ] = utc2date( utc_time )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
year = 1970;
day_clock = mod(utc_time,86400);
day_no = floor(double(utc_time)/86400);


hour = floor(day_clock/3600);
min = floor(double(mod(day_clock,3600))/60);
sec = mod(day_clock,60);

wd = mod(day_no + 4,7);

ys = year_size(year);

while day_no > ys{1}
    day_no = day_no - ys{1};
    year = year+1;
    ys = year_size(year);
end

y = year;
m = 1;

j = year_size(year, m);

while day_no >= j{2};
    if (double(day_no) - j{3}) < 0
        break;
    else
        day_no = day_no - j{3};
    end
    m = m + 1;
    j = year_size(year, m);
end
d = double(day_no)+1;
date_str = datestr(double([y m d hour min sec]),0);
end

