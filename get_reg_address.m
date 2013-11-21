function [ reg_address, field_name ] = get_reg_address( reg_name, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = evalin('base', 'data');

if nargin == 1
    coil_list = {'fsk_qualitaet' 'status_ext_temp_sensor' 'reserve1' 'reserve2' 'reserve3'};
    if strmatch(reg_name, coil_list) == 1
        reg_address = getfield(data.Communication_Settings.coil,reg_name);
        field_name = {'data.Communication_Settings'};
    else
        reg_address = getfield(data.Communication_Settings.register,reg_name);
        field_name = {'data.Communication_Settings'};
    end
else
    prog_detail_field = getfield(data,reg_name{1});
    if strcmp(reg_name{1},'keine Details verfügbar') == 1 || isempty(reg_name{2}) == 1
        prog_hour_field = getfield(prog_detail_field, char(varargin{1}(1)));
        reg_address = getfield(prog_hour_field, char(varargin{1}(2)));
        field_name = {'data.',reg_name{1},char(varargin{1}(1)),char(varargin{1}(2))};
    else
        prog_day_field = getfield(prog_detail_field,reg_name{2});
        prog_hour_field = getfield(prog_day_field, char(varargin{1}(1)));
        reg_address = getfield(prog_hour_field, char(varargin{1}(2)));
        field_name = {'data.',reg_name{1},reg_name{2},char(varargin{1}(1)),char(varargin{1}(2))};
    end
end
