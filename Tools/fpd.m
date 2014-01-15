function [ x, y, xi ] = fpd( prog1, prog2, data, resolution_in_dec, farbe, stemplot  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch resolution_in_dec
    case 1
        factor = 6;
    case 0.5
        if strcmp(prog2,'mittlere_temp_prog') == 1
            factor = 2;
        else
            factor = 12;
        end
    case 0.25
        if strcmp(prog2,'mittlere_temp_prog') == 1
            factor = 4;
        else
            factor = 24;
        end
    case 0.08
        if strcmp(prog2,'mittlere_temp_prog') == 1
            factor = 12;
        else
            factor = 72;
        end
end


hold on; 
if stemplot == 1
    if strcmp(prog2,'mittlere_temp_prog') == 1
        stem(data.(prog1).(prog2).unix_t_mean(25:factor:end),data.(prog1).(prog2).org_val(25:end),farbe);
        x = data.(prog1).(prog2).unix_t_mean(25:factor:end);
        y = data.(prog1).(prog2).org_val(25:end);
        xi = data.(prog1).(prog2).unix_t_mean,data;
    else
        stem(data.(prog1).(prog2).unix_t_mean(29:factor:end),data.(prog1).(prog2).org_val(5:end),farbe);
        x = data.(prog1).(prog2).unix_t_mean(29:factor:end);
        y = data.(prog1).(prog2).org_val(29:end);
        xi = data.(prog1).(prog2).unix_t_mean,data;
    end
    
else
    plot(data.(prog1).(prog2).unix_t_mean,data.(prog1).(prog2).int_val,farbe);
end
end