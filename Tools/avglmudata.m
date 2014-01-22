function [ x, avg_x, y, avg_y ] = avglmudata( data, ch, res, farbe, solar_flag)
%UNTITLED3 Summary of this function goes here
%   CH_ID	NAME	SINGLE_READING	STORAGE_INTERVAL	UNIT	DESCRIPTION
% 100	Lufttemperatur	0	3600	°C	Lufttemperatur in 2m Höhe
% 101	Feuchttemperatur	0	3600	°C	Feuchttemperatur in 2m Höhe
% 102	Windrichtung	0	3600	°	Windrichtung in 30m Höhe
% 103	Windgeschwindigkeit	0	3600	m/s	Windgeschwindigkeit in 30m Höhe
% 104	Niederschlag	0	3600	mm	Niederschlag
% 105	Himmelsstrahlung	0	3600	W/m^2	Himmelstrahlung in 30m Höhe
% 106	Globalstrahlung	0	3600	W/m^2	Globalstrahlung in 30m Höhe
% 200	Akt_Bodentemp_50cm	0	60	°C	Bodentemperatur in 50cm Tiefe
% 201	Akt_Bodentemp_20cm	0	60	°C	Bodentemperatur in 20cm Tiefe
% 202	Akt_Bodentemp_10cm	0	60	°C	Bodentemperatur in 10cm Tiefe
% 203	Akt_Bodentemp_05cm	0	60	°C	Bodentemperatur in 05cm Tiefe
% 204	Akt_Bodentemp_02cm	0	60	°C	Bodentemperatur in 02cm Tiefe
% 205	Akt_Lufttemp_02m	0	60	°C	Lufttemperatur in 02m Höhe
% 206	Akt_Lufttemp_30m	0	60	°C	Lufttemperatur in 30m Höhe
% 207	Akt_Feuchttemp_02m	0	60	°C	Feuchttemperatur in 02m Höhe
% 208	Akt_Feuchttemp_30m	0	60	°C	Feuchttemperatur in 30m Höhe
% 209	Akt_Taupunkttemp_02m	0	60	°C	Taupunkttemperatur in 02m Höhe
% 210	Akt_Taupunkttemp_30m	0	60	°C	Taupunkttemperatur in 30m Höhe
% 211	Akt_RelFeuchte_02m	0	60	%rF	Relative Feuchte in 02m Höhe
% 212	Akt_RelFeuchte_30m	0	60	%rF	Relative Feuchte in 30m Höhe
% 213	Akt_Windgeschwindigkeit_30m	0	60	m/s	Windgeschwindigkeit in 30m Höhe
% 214	Akt_Windrichtung_30m	0	60	°	Windrichtung in 30m Höhe
% 215	Akt_Niederschlag	0	60	mm	Niederschlag
% 216	Akt_Niederschlagssumme	0	60	mm	Niederschlagssumme seit 0 Uhr
% 217	Akt_Globalstrahlung	0	60	W/m^2	Globalstrahlung
% 218	Akt_Diffsstrahlung	0	60	W/m^2	Diffusstrahlung
% 219	Akt_Gegenstrahlung	0	60	W/m^2	Gegenstrahlung
% 220	Akt_Luftdruck	0	60	hPa	Luftdruck
% 221	Akt_UV_Index	0	60	-	UV Index
% 222	Akt_Sonnenscheindauer	0	60	min	Sonnenscheindauer in Minuten

for t = 1:size(data.(ch),1)
    if iscell(data.(ch){t}(2))
        x(t) = cell2mat(data.(ch){t}(4));
    else
        x(t) = double(data.(ch){t}(4));
    end
    if solar_flag == 1
        if iscell(data.(ch){t}(4))
            y(t) = cell2mat(data.(ch){t}(2))/60;
        else
            y(t) = double(data.(ch){t}(2))/60;
        end
    else
        if iscell(data.(ch){t}(4))
            y(t) = cell2mat(data.(ch){t}(2));
        else
            y(t) = double(data.(ch){t}(2));
        end
    end
end
x = double(x);
t = 1;
s = 1;
r = 1;
while t < size(y,2)
    if t == res*s;
    avg_y(s) = mean(y(r:t));
    avg_x(s) = x(t-(res-1));
    r = res*s+1;
    s = s + 1;
    end
    t = t + 1;
    if t > size(y,2)
        break;
    end
end

xdate = xdatecalc(avg_x);
plot(xdate,avg_y,farbe,'LineWidth',3),datetick('x',0,'keepticks');
end

