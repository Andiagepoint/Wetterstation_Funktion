function [ mse ] = mean_squared_error( xlmu, ylmu, xwd, ywd, start, ende )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s = 1;
r = 1;
summe = 0;
for t = 1:size(xlmu,2)
    if xlmu(t) - xwd(s) <= 60 && xlmu(t) - xwd(s) > 0
        if s < size(xwd,2)
        if  xwd(s) >= date2utc(datevec(start)) && xwd(s) <= date2utc(datevec(ende))
            summe = summe + (ywd(s)-ylmu(t))^2;
            r = r + 1;
            s = s + 1;
        else
            s = s + 1;
        end
        end
    end
end
mse = sqrt(summe/(r-1));
end

