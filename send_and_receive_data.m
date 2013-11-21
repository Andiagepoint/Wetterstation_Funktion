function [ value ] = send_and_receive_data( modbus_msg, field_name, hObject, handles, cycle_number )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
serial_interface = evalin('base','serial_interface');

txdata = format_modbus_msg(modbus_msg);

fwrite(serial_interface,txdata);

request_count = str2double(get(handles.com_protocol_request_quantity,'String')) + 1;
set(handles.com_protocol_request_quantity,'String',num2str(request_count));

request_protocol_text = sprintf('Successful request %s at %s', modbus_msg, datestr(now));

hcom_protocol_listbox = findobj('Tag','com_protocol_listbox');

listbox_text = get(hcom_protocol_listbox,'String');

pause(1);

if serial_interface.BytesAvailable == 0
    bytes_num = 8;
else
    bytes_num = serial_interface.BytesAvailable;
end

[rxdata] = fread(serial_interface, bytes_num, 'uint8');

[value, crc_check_value, response_msg, error_msg] = rxdata_proc( rxdata, modbus_msg, field_name, hObject, handles, cycle_number );

if crc_check_value == 0
   crc_check_text = sprintf('CRC Check failed');
else
   crc_check_text = sprintf('CRC Check was successful');
end

if ~isnan(error_msg)
    response_protocol_text = sprintf('Error: %s at %s', error_msg, datestr(now));
else
    response_protocol_text = sprintf('\nSuccessful response %s at %s \n', response_msg, datestr(now));
end

if crc_check_value ~= 0  && isempty(error_msg) == 1
    response_count = str2double(get(handles.com_protocol_response_quantity,'String')) + 1;
    set(handles.com_protocol_response_quantity,'String',num2str(response_count));
else
    error_count = str2double(get(handles.com_protocol_error_quantity,'String')) + 1;
    set(handles.com_protocol_error_quantity,'String',num2str(error_count));
end
    
listbox_text = char(listbox_text, request_protocol_text, crc_check_text, response_protocol_text, ' ');

set(hcom_protocol_listbox,'String',listbox_text);
% guidata(hObject,handles);
end

