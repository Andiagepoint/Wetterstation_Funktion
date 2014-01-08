function [ date_str ] = utc2date( utc_time )
%Converts unix time to date
%   Detailed explanation goes here

% Define start year of unix time calculation
year = 1970;
% Calculate how many seconds elapsed since 0.00 o'clock
day_clock = mod(utc_time,86400);
% Calculate how many days elapsed since 01.01.1970
day_no = floor(double(utc_time)/86400);

% Calculate elapsed hours, min, sec since 0.00 o'clock
hour = floor(day_clock/3600);
min = floor(double(mod(day_clock,3600))/60);
sec = mod(day_clock,60);

% wd = mod(day_no + 4,7);

% Define the number of days in year, considering leap years
ys = year_size(year);
% Reduce day_no by number of days in a year until day_no is less than a year
while day_no > ys{1}
    day_no = day_no - ys{1};
    year = year+1;
    ys = year_size(year);
end

y = year;
m = 1;

% Get the number of days in a year, the elapsed days since 01.01. of that
% year, and the number of days in a month starting with January
j = year_size(year, m);

% Loop until remaining day_no is less than elapsed days since 01.01. 
while day_no >= j{2};
    if (double(day_no) - j{3}) < 0
        break;
    else
% Subtract number of days in a month        
        day_no = day_no - j{3};
    end
% Increase number of elapsed month since 01.01.
    m = m + 1;
    j = year_size(year, m);
end
d = double(day_no)+1;
date_str = datestr(double([y m d hour min sec]),0);
end

