function [ proc_value ] = data_mult( dec_value, prog_detail )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here.
if strcmp(prog_detail,'Menge') == 1 || strcmp(prog_detail,'Dauer') == 1
        proc_value = dec_value/10;
else
        proc_value = dec_value;
end

end

