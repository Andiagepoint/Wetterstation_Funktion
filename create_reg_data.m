function [ data  ] = create_reg_data(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hour_rough = struct('Morgen',0, 'Vormittag',0, 'Nachmittag',0, 'Abend',0);
hour_detailed = struct('AM0_00',0,'AM01_00',0,'AM02_00',0,'AM03_00',0,'AM04_00',0,'AM05_00',0,'AM06_00',0,'AM07_00',0,'AM08_00',0,'AM09_00',0,'AM10_00',0,'AM11_00',0,'AM12_00',0,'PM01_00',0,'PM02_00',0,'PM03_00',0,'PM04_00',0,'PM05_00',0,'PM06_00',0,'PM07_00',0,'PM08_00',0,'PM09_00',0,'PM10_00',0,'PM11_00',0);
day_rough = struct('Heute',hour_rough, 'Erster_Folgetag',hour_rough, 'Zweiter_Folgetag',hour_rough, 'Dritter_Folgetag',hour_rough);
day_detailed = struct('Heute',hour_detailed, 'Erster_Folgetag',hour_detailed, 'Zweiter_Folgetag',hour_detailed, 'Dritter_Folgetag',hour_detailed);
markantes_wetter = struct('Bodennebel',day_rough,'Gefrierender_Regen',day_rough,'Bodenfrost',day_rough,'Boeen',day_rough,'Niederschlag',day_rough,'Hitze',day_rough,'Kaelte',day_rough);
niederschlag = struct('Menge',day_rough,'Wahrscheinlichkeit',day_rough);
wind = struct('Staerke',day_rough,'Richtung',day_rough);
solarleistung = struct('Dauer',day_rough,'Einstrahlung',day_rough);
temperatur = struct('Max',day_rough,'Min',day_rough,'Mittlere_temp_prog',day_detailed);

radio_clock = struct('sec','0064','min','0065','hour','0066','day','0067','month','0068','year','0069');
status = struct('fsk_qualitaet','0000','status_ext_temp_sensor','0001','reserve1','0002','reserve2','0003','reserve3','0004');
register = struct('temperature','0061','temperature_offset','0062','radio_clock',radio_clock,'transmitting_station','006E','quality','006F','city_id','0070');
coil = struct('status',status);
comset = struct('register',register,'coil',coil);

data = struct('Temperatur',temperatur,'Luftdruck',day_rough,'Markantes_Wetter',markantes_wetter,'Niederschlag',niederschlag,'Solarleistung',solarleistung,'Signifikantes_Wetter',day_rough,'Wind',wind,'Communication_Settings',comset);

[data] = regfill(390,data,'Temperatur','Mittlere_temp_prog');
[data] = regfill(400,data,'Temperatur','Max');
[data] = regfill(420,data,'Temperatur','Min');
[data] = regfill(140,data,'Niederschlag','Menge');
[data] = regfill(160,data,'Niederschlag','Wahrscheinlichkeit');
[data] = regfill(180,data,'Solarleistung','Dauer');
[data] = regfill(190,data,'Solarleistung','Einstrahlung');
[data] = regfill(200,data,'Wind','Staerke');
[data] = regfill(220,data,'Wind','Richtung');
[data] = regfill(250,data,'Markantes_Wetter','Bodennebel');
[data] = regfill(270,data,'Markantes_Wetter','Gefrierender_Regen');
[data] = regfill(290,data,'Markantes_Wetter','Bodenfrost');
[data] = regfill(310,data,'Markantes_Wetter','Boeen');
[data] = regfill(330,data,'Markantes_Wetter','Niederschlag');
[data] = regfill(350,data,'Markantes_Wetter','Hitze');
[data] = regfill(370,data,'Markantes_Wetter','Kaelte');
[data] = regfill(240,data,'Luftdruck','');
[data] = regfill(120,data,'Signifikantes_Wetter','');
[data] = regfill(0,data,'Temperatur','Mittlere_temp_prog');

clear hour_detailed
clear hour_rough
clear day_detailed
clear day_rough
clear markantes_wetter
clear niederschlag
clear wind
clear solarlseitung
clear temperatur
clear solarleistung
clear comset
clear coil
clear status
clear register
clear radio_clock

end

