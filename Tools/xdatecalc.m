function [ xdate ] = xdatecalc( wdx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for t=1:size(wdx,2)
    xdate(t) = datenum(utc2date(wdx(t)));
end
end

