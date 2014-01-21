function [ data  ] = create_reg_data(  )
%Create register data structure with addresses
%   Detailed explanation goes here

hour_rough = struct('morgen',0, 'vormittag',0, 'nachmittag',0, 'abend',0);
hour_detailed = struct('am0_00',0,'am01_00',0,'am02_00',0,'am03_00',0,'am04_00',0,'am05_00',0,'am06_00',0,'am07_00',0,'am08_00',0,'am09_00',0,'am10_00',0,'am11_00',0,'am12_00',0,'pm01_00',0,'pm02_00',0,'pm03_00',0,'pm04_00',0,'pm05_00',0,'pm06_00',0,'pm07_00',0,'pm08_00',0,'pm09_00',0,'pm10_00',0,'pm11_00',0);
day_rough = struct('heute',hour_rough, 'erster_folgetag',hour_rough, 'zweiter_folgetag',hour_rough, 'dritter_folgetag',hour_rough);
day_detailed = struct('heute',hour_detailed, 'erster_folgetag',hour_detailed, 'zweiter_folgetag',hour_detailed, 'dritter_folgetag',hour_detailed);
markantes_wetter = struct('bodennebel',day_rough,'gefrierender_regen',day_rough,'bodenfrost',day_rough,'boeen',day_rough,'niederschlag',day_rough,'hitze',day_rough,'kaelte',day_rough);
niederschlag = struct('menge',day_rough,'wahrscheinlichkeit',day_rough);
wind = struct('staerke',day_rough,'richtung',day_rough);
solarleistung = struct('dauer',day_rough,'einstrahlung',day_rough);
temperatur = struct('max',day_rough,'min',day_rough,'mittlere_temp_prog',day_detailed);
x = struct('x',day_rough);

radio_clock = struct('sec','0064','min','0065','hour','0066','day','0067','month','0068','year','0069');
status = struct('fsk_qualitaet','0000','status_ext_temp_sensor','0001','reserve1','0002','reserve2','0003','reserve3','0004');
register = struct('temperature','0061','temperature_offset','0062','radio_clock',radio_clock,'transmitting_station','006E','quality','006F','city_id','0070');
coil = struct('status',status);
comset = struct('register',register,'coil',coil);

data = struct('temperatur',temperatur,'luftdruck',x,'markantes_wetter',markantes_wetter,'niederschlag',niederschlag,'solarleistung',solarleistung,'signifikantes_wetter',x,'wind',wind,'communication_settings',comset);

[data] = register_fill(390,data,'temperatur','mittlere_temp_prog');
[data] = register_fill(400,data,'temperatur','max');
[data] = register_fill(420,data,'temperatur','min');
[data] = register_fill(140,data,'niederschlag','menge');
[data] = register_fill(160,data,'niederschlag','wahrscheinlichkeit');
[data] = register_fill(180,data,'solarleistung','dauer');
[data] = register_fill(190,data,'solarleistung','einstrahlung');
[data] = register_fill(200,data,'wind','staerke');
[data] = register_fill(220,data,'wind','richtung');
[data] = register_fill(250,data,'markantes_wetter','bodennebel');
[data] = register_fill(270,data,'markantes_wetter','gefrierender_regen');
[data] = register_fill(290,data,'markantes_wetter','bodenfrost');
[data] = register_fill(310,data,'markantes_wetter','boeen');
[data] = register_fill(330,data,'markantes_wetter','niederschlag');
[data] = register_fill(350,data,'markantes_wetter','hitze');
[data] = register_fill(370,data,'markantes_wetter','kaelte');
[data] = register_fill(240,data,'luftdruck','x');
[data] = register_fill(120,data,'signifikantes_wetter','x');
[data] = register_fill(0,data,'temperatur','mittlere_temp_prog');

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

