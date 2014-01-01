function [ CityID_correct, CityID ] = get_city_id( CityName )
%Gets the city id from the city list
%   Detailed explanation goes here
CityList = evalin('base','CityList');
CityList.CityName = nominal(CityList.CityName);
CityID = CityList(CityList.CityName == CityName,:);
if isempty(CityID)
    CityID_correct = 0;
else
    CityID = CityID{:,1};
    CityID_correct = 1;
end
end

