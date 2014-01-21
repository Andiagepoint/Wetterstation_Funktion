function [ city_id_correct, city_id, longitude, latitude ] = get_city_id( cityname )
%Gets the city id from the city list
%   Detailed explanation goes here
citylist = evalin('base','city_list');
citylist.CityName = nominal(citylist.CityName);
city_id_dataset = citylist(citylist.CityName == cityname,:);
if isempty(city_id_dataset)
    city_id_correct = 0;
    city_id = '';
    longitude = '';
    latitude = '';
else
    city_id = city_id_dataset{:,1};
    longitude = city_id_dataset{:,3};
    latitude = city_id_dataset{:,4};
    city_id_correct = 1;
end
end

