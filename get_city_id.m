function [ CityID ] = get_city_id( CityName )
%Gets the city id from the city list
%   Detailed explanation goes here
CityList = evalin('base','CityList');
CityList.CityName = nominal(CityList.CityName);
CityID = CityList(CityList.CityName == CityName,:);
if isempty(CityID)
    error(['F�r diese Stadt k�nnen keine Wetterdaten' ...
           ' abgerufen werden. Bitte �berpr�fen Sie, ob Sie ' ...
           'den Namen der Stadt richtig geschrieben haben.' ...
           ' Eine alphabetisch geordnete Liste mit den verf�gbaren' ...
           ' St�dten finden Sie in CityList_sorted.']);
else
CityID = CityID{:,1};
end
end

