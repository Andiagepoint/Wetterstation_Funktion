function [ correct_input, error_msg, city_id ] = input_check( forecast_detail, update_start_date, update_end_date, city_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[correct_input(1), city_id] = get_city_id(city_name);

if correct_input(1) == 0
    error_msg{1} = ['Diese Stadt kann in der CityList nicht gefunden werden: ' ...
           city_name];
end

check = strfind(forecast_detail,'-');

if size(check,2) ~= 2
    correct_input(2)    = 0;
    error_msg{2}        = ['Das forecast_detail wurde nicht korrekt definiert: ' char(forecast_detail)];
    
else
    correct_input(2)    = 1;

    forecast_detail     = regexp(forecast_detail,'-','split');

    forecast_scope      = {'niederschlag', 'wind', 'temperatur', 'solarleistung', ...
                           'markantes_wetter', 'signifikantes_wetter', 'luftdruck'};
    forecast_details    = {'x', 'richtung', 'staerke', 'min', 'max', ...
                           'mittlere_temp_prog' ...
                           'dauer', 'einstrahlung', 'boeen', 'bodenfrost', ...
                           'gefrierender_regen', 'menge', 'kaelte', 'hitze', ...
                           'bodennebel', 'wahrscheinlichkeit', 'niederschlag'};
    forecast_interval   = {'1','2','3','all'};

    correct_input(3)    = ismember(forecast_detail{1},forecast_scope);
    correct_input(4)    = ismember(forecast_detail{2},forecast_details);
    correct_input(5)    = ismember(forecast_detail{3},forecast_interval);

    if correct_input(3) == 0
        error_msg{3}    = ['Bitte überprüfen Sie den Prognosebereich: ' forecast_detail{1}];
    end
    if correct_input(4) == 0
        error_msg{4}    = ['Bitte überprüfen Sie das Prognosedetail: ' forecast_detail{2}];
    end
    if correct_input(5) == 0
        error_msg{5}    = ['Bitte überprüfen Sie das Prognoseintervall: ' forecast_detail{3}];
    end
    
end

diff_days               = days365(update_start_date,update_end_date)*24;

if diff_days < 0
    correct_input(6)    = 0;
    error_msg{6}        = (['Das Startdatum für den Beobachtungszeitraum muss vor' ...
          ' dem Enddatum liegen! Bitte korrigieren Sie die Datumseingabe.']);
elseif days365(date,update_start_date) < 0
    correct_input(6)    = 0;
    error_msg{6}        = ('Das Startdatum liegt in der Vergangenheit!');
else
    correct_input(6)    = 1;
end

if true(correct_input)
    error_msg           = NaN;
elseif size(error_msg,2) < 6
    error_msg{6}        = [];
end


end

