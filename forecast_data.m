function [ output_args ] = forecast_data( CityName, forecast_scope, forecast_detail, forecast_interval, automatic_call_interval , resolution )
% Example
% forecast_data('München','Niederschlag','Menge','Heute-Morgen-3.Folgetag-Abend','23-25-Nov-2013','1')
%   Detailed explanation goes here

% General variable settings
fcode_read_sr   = '03';
fcode_write_sr  = '06';
device_id       = '03';

% Adresse für die Wetterregion in Holdingregister 112
% Adresse für die Sendestation in Holdingregister 110
reg_add_weather_region      = {'city_id'};
reg_add_station_location    = {'transmitting_station'};

% Check for available COM Ports
av_com_ports = instrhwinfo('serial');
com_port_av = find(ismember(av_com_ports.AvailableSerialPorts,'COM6'));
if isempty(com_port_av)
    fprintf('%s \n','COM Port ist nicht verfügbar');
    return;
end
    
% Open serial interface
open_serial_port( 'COM6', 9600, 8, 'none', 1 );

% Read city_id value in holding register
value = read_sr(device_id, reg_add_weather_region);

% Compare city_id and value, if values differ, we have to write the new
% city_id to the relevant register.

[ city_id ] = get_city_id( CityName );

if city_id ~= value
   write_sr( device_id, city_id, reg_add_weather_region ) 
end
    

output_args = 0;


end

