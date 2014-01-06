function [ city_id_correct, city_id ] = get_city_id( cityname )
%Gets the city id from the city list
%   Detailed explanation goes here
citylist = evalin('base','city_list');
citylist.CityName = nominal(citylist.CityName);
city_id = citylist(citylist.CityName == cityname,:);
if isempty(city_id)
    city_id_correct = 0;
else
    city_id = city_id{:,1};
    city_id_correct = 1;
end
end

