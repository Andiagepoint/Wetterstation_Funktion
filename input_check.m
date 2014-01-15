function [ correct_input, error_msg, city_id, longitude, latitude ] = input_check( forecast_detail, update_start_date, update_end_date, city_name, resolution )
%Checks all input parameter if valid or not and displays wrong parameters
%   Detailed explanation goes here

% Check for the right spelling and availability of city name
% correct_input(1) will be 1 for existence and city_id contains the numeric
% city id.
[correct_input(1), city_id, longitude, latitude] = get_city_id(city_name);

% Create failure message for a non existent city name
if correct_input(1) == 0
    error_msg{1} = ['Diese Stadt kann in der CityList nicht gefunden werden: ' ...
           city_name];
end

% Check for the right definition of forecast, required scheme
% 'forecast_scope-forecast_detail-interval'
check = strfind(forecast_detail,'-');

% Create failure message if less or more then two '-' are existent in the
% forecast definition string
if size(check,2) ~= 2
    correct_input(2)    = 0;
    error_msg{2}        = ['Das forecast_detail wurde nicht korrekt definiert: ' char(forecast_detail)];
    
% If no error put correct_input(2) to 1
else
    correct_input(2)    = 1;
% Disjoint the forecast definition into seperate parts (1) forecast_scope
% (2) forecast_detail (3) forecast_interval
    forecast_detail     = regexp(forecast_detail,'-','split');
% Define the possible values for each part of the forecast definition
    forecast_scope      = {'niederschlag', 'wind', 'temperatur', 'solarleistung', ...
                           'markantes_wetter', 'signifikantes_wetter', 'luftdruck'};
    forecast_details    = {'x', 'richtung', 'staerke', 'min', 'max', ...
                           'mittlere_temp_prog' ...
                           'dauer', 'einstrahlung', 'boeen', 'bodenfrost', ...
                           'gefrierender_regen', 'menge', 'kaelte', 'hitze', ...
                           'bodennebel', 'wahrscheinlichkeit', 'niederschlag'};
    forecast_interval   = {'1','2','3','all'};
    resolution_values   = {'6','1','0.5','0.25','0.08'};
% Determine if the input values are member of those lists defined above. If
% this is the case correct_input values will be 1.
    correct_input(3)    = ismember(forecast_detail{1},forecast_scope);
    correct_input(4)    = ismember(forecast_detail{2},forecast_details);
    correct_input(5)    = ismember(forecast_detail{3},forecast_interval);
% If any input value doesn�t exist in the list, create error message.
    if correct_input(3) == 0
        error_msg{3}    = ['Bitte �berpr�fen Sie den Prognosebereich: ' forecast_detail{1}];
    end
    if correct_input(4) == 0
        error_msg{4}    = ['Bitte �berpr�fen Sie das Prognosedetail: ' forecast_detail{2}];
    end
    if correct_input(5) == 0
        error_msg{5}    = ['Bitte �berpr�fen Sie das Prognoseintervall: ' forecast_detail{3}];
    end
    
end

% Calculate the difference of days between the observation start and end
% date. 
diff_days               = days365(update_start_date,update_end_date)*24;

% If the difference is negative, the end date comes previous to the start
% date which is not possible.
if diff_days < 0
    correct_input(6)    = 0;
    error_msg{6}        = (['Das Startdatum f�r den Beobachtungszeitraum muss vor' ...
          ' dem Enddatum liegen! Bitte korrigieren Sie die Datumseingabe.']);
% Same procedure with the start date, which never comes previous to the
% current date.
elseif days365(date,update_start_date) < 0
    correct_input(6)    = 0;
    error_msg{6}        = ('Das Startdatum liegt in der Vergangenheit!');
else
    correct_input(6)    = 1;
end

    correct_input(7)    = ismember(num2str(resolution),resolution_values);
    
if correct_input(7) == 0
    error_msg{7}        = ('F�r die Aufl�sung k�nnen nur folgende Werte eingegeben werden: 6, 1, 0.5, 0.25, 0.08!');
end 
% If no error exists don�t return a error msg or if there are less than 6
% error messages, make the last error message empty so it could be
% displayed in the fprintf command.
if true(correct_input)
    error_msg           = NaN;
elseif size(error_msg,2) < 7
    error_msg{7}        = [];
end


end

