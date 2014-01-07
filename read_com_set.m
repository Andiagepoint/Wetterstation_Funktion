function [ request_value ] = read_com_set( device_id, request_list )
%This function reads the holding register, where communication settings are
%stored. E.g. read_com_set('03',{city_id})
%
%   device_id  has to be '03'
%
%   To get the index for the actual weather region the station receives forecasts 
%   request_list has to be {'city_id'}
%
%   To get the connection quality request_list has to be {'quality'}
%
%   To get the transmitting station id from which data are received set
%   request_list {'transmitting_station'}
%
%   To get all more data with a single call just build a cell array for
%   the request_list with the interested objects like {'city_id','quality'}
%   The results are sorted in the way the request_list was grouped.

% Progress bar to show processing time
if size(request_list,2) > 1
    wb = waitbar(0,'Please wait while reading registers...');

    % Send request for each list element 
    for t = 1:size(request_list,2)
        waitbar(t/size(request_list,2))

        % Get register address from struct
        [reg_address, field_name] = get_reg_address(request_list{t});

        % As only one value has to be set, the number of registers is
        % restricted to 0x0001
        reg_num = '0001';

        % Generate modbus message 'rr' indicates a read register operation
        modbus_msg = gen_msg(device_id, reg_address, reg_num, 'rr');

        % Send message and evaluate the response, write status to protocol
        request_value(t) = send_and_receive_data(modbus_msg, field_name,'','');
    end

    close(wb);
else
    % Get register address from struct
    [reg_address, field_name] = get_reg_address(request_list{1});
    
    % As only one value has to be set, the number of registers is
    % restricted to 0x0001
    reg_num = '0001';
    
    % Generate modbus message 'rr' indicates a read register operation
    modbus_msg = gen_msg(device_id, reg_address, reg_num, 'rr');
    
    % Send message and evaluate the response, write status to protocol
    request_value = send_and_receive_data(modbus_msg, field_name, '', '');
end

end

