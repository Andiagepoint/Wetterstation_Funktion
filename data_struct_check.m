function [ ] = data_struct_check( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Error when no data struct is available 
if evalin('base','exist(''data'')') == 0
    error('Please load data struct to workspace to continue!');
end

end

