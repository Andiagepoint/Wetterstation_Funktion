function [ request_value ] = read_sr( device_id, request_list, hObject, handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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
        request_value(t) = send_and_receive_data(modbus_msg, field_name, hObject, handles,'');
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
    request_value = send_and_receive_data(modbus_msg, field_name, hObject, handles, '');
end

end

