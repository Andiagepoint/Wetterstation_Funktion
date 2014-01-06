function [ reg_address, field_name ] = get_reg_address( varargin )
%Gets the register number as hex value 
%   Detailed explanation goes here
register_data_hwk_kompakt   = evalin('base', 'register_data_hwk_kompakt');

if nargin == 1
    
    coil_list               = {'fsk_qualitaet' 'status_ext_temp_sensor' 'reserve1' 'reserve2' 'reserve3'};
    
    if strmatch(varargin, coil_list) == 1
        
        reg_address         = getfield(register_data_hwk_kompakt.communication_settings.coil,char(varargin));
        field_name          = {'register_data_hwk_kompakt.communication_settings'};
        
    elseif ~isempty(cell2mat(strfind(varargin,'radio_clock')))
        
        varargin            = regexp(char(varargin),'[.]','split');
        
        reg_address         = getfield(register_data_hwk_kompakt.communication_settings.register.radio_clock,char(varargin(2)));
        field_name          = {'register_data_hwk_kompakt.communication_settings'};
        
    else
        
        reg_address         = getfield(register_data_hwk_kompakt.communication_settings.register,char(varargin));
        field_name          = {'register_data_hwk_kompakt.communication_settings'};
        
    end
    
else
    
    prog_detail_field       = getfield(register_data_hwk_kompakt,varargin{1});
    
    if strcmp(varargin{2},'') == 1 || isempty(varargin{2}) == 1
        
        prog_hour_field     = getfield(prog_detail_field, char(varargin{3}(1)));
        reg_address         = getfield(prog_hour_field, char(varargin{3}(2)));
        field_name          = {'register_data_hwk_kompakt.',varargin{1},varargin{2},char(varargin{3}(1)),char(varargin{3}(2))};
        
    else
        
        prog_day_field      = getfield(prog_detail_field,varargin{2});
        prog_hour_field     = getfield(prog_day_field, char(varargin{3}(1)));
        reg_address         = getfield(prog_hour_field, char(varargin{3}(2)));
        field_name          = {'register_data_hwk_kompakt.',varargin{1},varargin{2},char(varargin{3}(1)),char(varargin{3}(2))};
        
    end
    
end
