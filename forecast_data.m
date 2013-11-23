function [ output_args ] = forecast_data( city, forecast_scope, forecast_detail, forecast_interval, automatic_call_interval , resolution )
% Example
% forecast_data('München','Niederschlag','Menge','Heute-Morgen-3.Folgetag-Abend','23-25-Nov-2013','1')
%   Detailed explanation goes here

% General variable settings
fcode_read_sr   = '03';
fcode_write_sr  = '06';
device_id       = '03';

reg_add_weather_region      = dec2hex(112);
reg_add_station_location    = dec2hex(110);

% Open serial interface
open_serial_port( 'COM6', 19200, 8, 'even', 1 );

% Read value from register address where the city id is stored. If values
% differ, write new value to register.

% Create modbus message
[modbus_pdu] = gen_pdu(device_id,fcode_read_sr,reg_add_weather_region,'0001');
[ txdata_hex ] = crc_calc( modbus_pdu );
[ txdata ] = format_modbus_msg( txdata_hex );


[ CityID ] = get_city_id( CityName );


end

