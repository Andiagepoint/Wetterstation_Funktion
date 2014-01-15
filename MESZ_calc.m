function [ MEZ ] = MESZ_calc(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
years = {'2013','2014','2015','2016','2017','2018','2019','2020'};
                
t_tbl_f_MESZ_change = {'31-Mar-2013 02:00:00' ,'30-Mar-2014 02:00:00' ,...
                       '29-Mar-2015 02:00:00' ,'27-Mar-2016 02:00:00',...
                       '26-Mar-2017 02:00:00' ,'25-Mar-2018 02:00:00',...
                       '31-Mar-2019 02:00:00' ,'29-Mar-2020 02:00:00'};

t_tbl_f_MEZ_change = {'27-Oct-2013 03:00:00', '26-Oct-2014 03:00:00',...
                      '25-Oct-2015 03:00:00', '30-Oct-2016 03:00:00',...
                      '29-Oct-2017 03:00:00', '28-Oct-2018 03:00:00',...
                      '27-Oct-2019 03:00:00', '25-Oct-2020 03:00:00'};

[a,b] = ismember(datestr(date,10),years);

if a == 1
    if now > datenum(t_tbl_f_MESZ_change{b}) && now < datenum(t_tbl_f_MEZ_change{b})
        MEZ = 0;
    else
        MEZ = 1;
    end
else
    fprintf(2,'Liste mit Zeitumstellung muss aktualisiert werden!!!!\n', char(10))
    error('Problem mit Zeitumstellung');
end
end

