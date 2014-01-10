function [  ] = plot_data( prog1, prog2, data, resolution, farbe  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch resolution
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



plot(data.(prog1).(prog2).unix_t_strt,data.(prog1).(prog2).int_val,farbe);
hold on;
stem(data.(prog1).(prog2).unix_t_strt(1:factor:end),data.(prog1).(prog2).org_val,farbe);


end