function [ mse ] = mean_squared_error( xlmu, ylmu, xwd, ywd )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s = 1;
summe = 0;
for t = 1:size(xlmu,2)
    if xlmu(t) - xwd(s) <= 60 && xlmu(t) - xwd(s) > 0
        summe = summe + (ywd(s)-ylmu(t))^2;
        s = s + 1;
    end
end
mse = summe/(s-1);
end

