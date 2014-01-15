function [ factor ] = res_factor( resolution, f_c_d )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
switch resolution
    
    case 6
        factor = 1;
    case 1
        if strcmp(f_c_d,'mittlere_temp_prog') == 1
            factor = 1;
        else
            factor = 6;
        end
    case 0.5
        if strcmp(f_c_d,'mittlere_temp_prog') == 1
            factor = 2;
        else
            factor = 12;
        end
    case 0.25
        if strcmp(f_c_d,'mittlere_temp_prog') == 1
            factor = 4;
        else
            factor = 24;
        end
    case 0.08
        if strcmp(f_c_d,'mittlere_temp_prog') == 1
            factor = 12;
        else
            factor = 72;
        end
        
end

end

