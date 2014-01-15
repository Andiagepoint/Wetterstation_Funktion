function [ data_struct ] = create_data_struct( field_name, data_struct, struct_name )
%Create data container structure
%   Detailed explanation goes here

field_name              = regexp(field_name,'-','split');

min                     = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
max                     = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
mittlere_temp_prog      = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
menge                   = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
dauer                   = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
wahrscheinlichkeit      = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
einstrahlung            = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
richtung                = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
staerke                 = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
bodennebel              = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
gefrierender_regen      = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
bodenfrost              = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
boeen                   = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
kaelte                  = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
hitze                   = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
niederschlag            = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
luftdruck               = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);
signifikantes_wetter    = struct('unix_t_strt',[],'unix_t_end',[],'unix_t_mean',[],'unix_t_rec',[],'interval_t_clr',[],'unit',[],'info',[],'int_val',[],'org_val',[],'org_unix_t_strt',[],'org_unix_t_end',[],'con_qual',[]);


switch field_name{1}
    case 'temperatur'
        if strcmp(field_name{2},'min') == 1
                data_struct.(field_name{1}).(field_name{2}) = min;
                data_struct.(field_name{1}).(field_name{2}).unit = '°C';
                data_struct.(field_name{1}).(field_name{2}).info = 'min. Lufttemperatur 2m ü. Erdboden';
        elseif strcmp(field_name{2},'max') == 1
                data_struct.(field_name{1}).(field_name{2}) = max;
                data_struct.(field_name{1}).(field_name{2}).unit = '°C';
                data_struct.(field_name{1}).(field_name{2}).info = 'max. Lufttemperatur 2m ü. Erdboden';
        else
                data_struct.(field_name{1}).(field_name{2}) = mittlere_temp_prog;
                data_struct.(field_name{1}).(field_name{2}).unit = '°C';
                data_struct.(field_name{1}).(field_name{2}).info = 'mittlere Lufttemperatur 2m ü. Erdboden';
        end
    case 'niederschlag'
        if strcmp(field_name{2},'menge') == 1
                data_struct.(field_name{1}).(field_name{2}) = menge;
                data_struct.(field_name{1}).(field_name{2}).unit = 'l/m²';
                data_struct.(field_name{1}).(field_name{2}).info = '';
        else
                data_struct.(field_name{1}).(field_name{2}) = wahrscheinlichkeit;
                data_struct.(field_name{1}).(field_name{2}).unit = '%';
                data_struct.(field_name{1}).(field_name{2}).info = '';
        end
    case 'solarleistung'
        if strcmp(field_name{2},'dauer') == 1
                data_struct.(field_name{1}).(field_name{2}) = dauer;
                data_struct.(field_name{1}).(field_name{2}).unit = 'h';
                data_struct.(field_name{1}).(field_name{2}).info = '';
        else
                data_struct.(field_name{1}).(field_name{2}) = einstrahlung;
                data_struct.(field_name{1}).(field_name{2}).unit = 'W/m²';
                data_struct.(field_name{1}).(field_name{2}).info = '';
        end
    case 'wind'
        if strcmp(field_name{2},'staerke') == 1
                data_struct.(field_name{1}).(field_name{2}) = staerke;
                data_struct.(field_name{1}).(field_name{2}).unit = 'Bft';
                data_struct.(field_name{1}).(field_name{2}).info = 'in einer Höhe von 10m ü. Erdboden';
        else 
                data_struct.(field_name{1}).(field_name{2}) = richtung;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = 'N/NO/O/SO/S/SW/W/NW -> 1...8';
        end
    case 'luftdruck'
                data_struct.(field_name{1}).(field_name{2}) = luftdruck;
                data_struct.(field_name{1}).(field_name{2}).unit = 'hPa';
                data_struct.(field_name{1}).(field_name{2}).info = '';
    case 'signifikantes_wetter'
                data_struct.(field_name{1}).(field_name{2}) = signifikantes_wetter;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '1 = sonnig,klar 2 = leicht bewölkt 3 = vorwiegend bewölkt 4 = bedeckt 5 = Wärmegewitter 6 = starker Regen 7 = Schneefall 8 = Nebel 9 = Schneeregen 10 = Regenschauer 11 = leichter Regen 12 = Schneeschauer 13 = Frontengewitter 14 = Hochnebel 15 = Schneeregenschauer';
    case 'markantes_wetter'
        switch field_name{2}
            case 'bodennebel'
                data_struct.(field_name{1}).(field_name{2}) = bodennebel;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '1 = Wahrscheinlichkeit > 50%, Sichtweite unter 200m';
            case 'gefrierender_regen'
                data_struct.(field_name{1}).(field_name{2}) = gefrierender_regen;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '1 = Wahrscheinlichkeit > 50%';
            case 'bodenfrost'
                data_struct.(field_name{1}).(field_name{2}) = bodenfrost;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '1 = <0°C 5cm ü. Erdboden';
            case 'boeen'
                data_struct.(field_name{1}).(field_name{2}) = boeen;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '0 = keine Böen 1 = 45km/h starke Böen 2 = 72km/h stürmische Böen 3 = 99km/h orkanartige Böen';
            case 'niederschlag'
                data_struct.(field_name{1}).(field_name{2}) = niederschlag;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '0 = kein starker Niederschlag 1 = 10mm starker Niederschlag 2 = 50mm sehr starker Niederschlag';
            case 'hitze'
                data_struct.(field_name{1}).(field_name{2}) = hitze;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '0 = keine Meldung 1 = 27-31°C 2 = 32-40°C 3 = 41-53°C 4 = >54°C';
            case 'kaelte'
                data_struct.(field_name{1}).(field_name{2}) = kaelte;
                data_struct.(field_name{1}).(field_name{2}).unit = '';
                data_struct.(field_name{1}).(field_name{2}).info = '0 = keine Meldung 1 = <-15°C 2 = <-20°C 3 = <-25°C 4 = <-30°C';
        end   
end

if strcmp(struct_name,'weather_data') == 1
    assignin('base','weather_data',data_struct);
elseif strcmp(struct_name,'new_data') == 1
    assignin('base','new_data',data_struct);
end

end

