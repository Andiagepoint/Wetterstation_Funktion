function [ x, y, xi ] = fpd( prog1, prog2, data, resolution_in_dec, farbe, stemplot, lw  )
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
        xdate = xdatecalc(data.(prog1).(prog2).unix_t_mean(1:factor:end));
        stem(xdate,data.(prog1).(prog2).org_val(1:end),farbe,'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',10), datetick('x',0,'keepticks');
        x = data.(prog1).(prog2).unix_t_mean(1:factor:end);
        y = data.(prog1).(prog2).org_val(1:end);
        xi = data.(prog1).(prog2).unix_t_mean,data;
    else
        if strcmp(prog2,'menge') == 1
        xdate = xdatecalc(data.(prog1).(prog2).unix_t_mean(1:factor:end));
        stem(xdate,data.(prog1).(prog2).org_val(1:end)./72,farbe,'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',10), datetick('x',0,'keepticks');
        x = data.(prog1).(prog2).unix_t_mean(1:factor:end);
        y = data.(prog1).(prog2).org_val(1:end);
        xi = data.(prog1).(prog2).unix_t_mean,data;
        else
        xdate = xdatecalc(data.(prog1).(prog2).unix_t_mean(1:factor:end));
        stem(xdate,data.(prog1).(prog2).org_val(1:end),farbe,'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',10), datetick('x',0,'keepticks');
        x = data.(prog1).(prog2).unix_t_mean(1:factor:end);
        y = data.(prog1).(prog2).org_val(1:end);
        xi = data.(prog1).(prog2).unix_t_mean,data;
        end
    end
    
else
    if strcmp(prog2,'menge') == 1
        xdate = xdatecalc(data.(prog1).(prog2).unix_t_mean);
        plot(xdate,data.(prog1).(prog2).int_val./72,farbe, 'LineWidth', lw), datetick('x',0,'keepticks');
    else
        xdate = xdatecalc(data.(prog1).(prog2).unix_t_mean);
        plot(xdate,data.(prog1).(prog2).int_val,farbe, 'LineWidth', lw), datetick('x',0,'keepticks');
    end
end
end