function [ data_struct ] = create_data_struct( field_name, data_struct, struct_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

field_name              = regexp(field_name,'-','split');

min                     = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
max                     = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
mittlere_temp_prog      = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
menge                   = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
dauer                   = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
wahrscheinlichkeit      = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
einstrahlung            = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
richtung                = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
staerke                 = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
bodennebel              = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
gefrierender_regen      = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
bodenfrost              = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
boeen                   = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
kaelte                  = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
hitze                   = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
niederschlag            = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
luftdruck               = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);
signifikantes_wetter    = struct('unix_time_start',[],'unix_time_end',[],'unix_time_record',[],'interval_time_clear',[],'unit',[],'value',[]);


switch field_name{1}
    case 'temperatur'
        if strcmp(field_name{2},'min') == 1
                unit = '°C min. Lufttemperatur 2m ü. Erdboden';
                data_struct.(field_name{1}).(field_name{2}) = min;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        elseif strcmp(field_name{2},'max') == 1
                unit = '°C max. Lufttemperatur 2m ü. Erdboden';
                data_struct.(field_name{1}).(field_name{2}) = max;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        else
                unit = '°C mittlere Lufttemperatur 2m ü. Erdboden';
                data_struct.(field_name{1}).(field_name{2}) = mittlere_temp_prog;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        end
    case 'niederschlag'
        if strcmp(field_name{2},'menge') == 1
                unit = 'l/m²';
                data_struct.(field_name{1}).(field_name{2}) = menge;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        else
                unit = '%';
                data_struct.(field_name{1}).(field_name{2}) = wahrscheinlichkeit;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        end
    case 'solarleistung'
        if strcmp(field_name{2},'dauer') == 1
                unit = 'h';
                data_struct.(field_name{1}).(field_name{2}) = dauer;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        else
                unit = 'W/m²';
                data_struct.(field_name{1}).(field_name{2}) = einstrahlung;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        end
    case 'wind'
        if strcmp(field_name{2},'staerke') == 1
                unit = 'Bft in einer Höhe von 10m ü. Erdboden';
                data_struct.(field_name{1}).(field_name{2}) = staerke;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        else 
                unit = 'N/NO/O/SO/S/SW/W/NW -> 1...8';
                data_struct.(field_name{1}).(field_name{2}) = richtung;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        end
    case 'luftdruck'
                unit = 'hPa';
                data_struct.(field_name{1}).(field_name{2}) = luftdruck;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
    case 'signifikantes_wetter'
                unit = '1 = sonnig,klar 2 = leicht bewölkt 3 = vorwiegend bewölkt 4 = bedeckt 5 = Wärmegewitter 6 = starker Regen 7 = Schneefall 8 = Nebel 9 = Schneeregen 10 = Regenschauer 11 = leichter Regen 12 = Schneeschauer 13 = Frontengewitter 14 = Hochnebel 15 = Schneeregenschauer';
                data_struct.(field_name{1}).(field_name{2}) = signifikantes_wetter;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
    case 'markantes_wetter'
        switch field_name{2}
            case 'bodennebel'
                unit = '1 = Wahrscheinlichkeit > 50%, Sichtweite unter 200m';
                data_struct.(field_name{1}).(field_name{2}) = bodennebel;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'gefrierender_regen'
                unit = '1 = Wahrscheinlichkeit > 50%';
                data_struct.(field_name{1}).(field_name{2}) = gefrierender_regen;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'bodenfrost'
                unit = '1 = <0°C 5cm ü. Erdboden';
                data_struct.(field_name{1}).(field_name{2}) = bodenfrost;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'boeen'
                unit = '0 = keine Böen 1 = 45km/h starke Böen 2 = 72km/h stürmische Böen 3 = 99km/h orkanartige Böen';
                data_struct.(field_name{1}).(field_name{2}) = boeen;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'niederschlag'
                unit = '0 = kein starker Niederschlag 1 = 10mm starker Niederschlag 2 = 50mm sehr starker Niederschlag';
                data_struct.(field_name{1}).(field_name{2}) = niederschlag;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'hitze'
                unit = '0 = keine Meldung 1 = 27-31°C 2 = 32-40°C 3 = 41-53°C 4 = >54°C';
                data_struct.(field_name{1}).(field_name{2}) = hitze;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
            case 'kaelte'
                unit = '0 = keine Meldung 1 = <-15°C 2 = <-20°C 3 = <-25°C 4 = <-30°C';
                data_struct.(field_name{1}).(field_name{2}) = kaelte;
                data_struct.(field_name{1}).(field_name{2}).unit = unit;
        end   
end

if strcmp(struct_name,'weather_data') == 1
    assignin('base','weather_data',data_struct);
elseif strcmp(struct_name,'new_data') == 1
    assignin('base','new_data',data_struct);
end

end

