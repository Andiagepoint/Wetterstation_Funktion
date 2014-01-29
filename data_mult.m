function [ proc_value ] = data_mult( dec_value, prog_detail )
%Processes values from Niederschlagsmenge and Sonnenscheindauer to get
%units in l/m² and h.
%   Detailed explanation goes here.
if strcmp(prog_detail,'menge') == 1 || strcmp(prog_detail,'dauer') == 1
        proc_value = dec_value/10;
else
        proc_value = dec_value;
end

end

