function [ unix_zeit ] = date2utc( date_vector )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

jahr = uint64(date_vector(1));
monat = uint64(date_vector(2));
tag = uint64(date_vector(3));
std = uint64(date_vector(4));
min = uint64(date_vector(5));
sec = uint64(date_vector(6));
tage_seit_jahresanfang = {0,31,59,90,120,151,181,212,243,273,304,334};
jahre = jahr - 1970;
schaltjahre = floor(((jahr-1)-1968)/4)-floor(((jahr-1)-1900)/100)+floor(((jahr-1)-1600)/400);
unix_zeit=sec+60*min+3600*std+(tage_seit_jahresanfang{monat}+tag-1)*86400+(365*jahre+schaltjahre)*86400;

end


