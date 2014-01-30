function [ fcode_error ] = fcode_check( fcode )
%Check whether function code is valid or not
%   Detailed explanation goes here
switch fcode
    case dec2hex(1,2)
    fcode_error = 0;    
    case dec2hex(3,2)
    fcode_error = 0;       
    case dec2hex(6,2)
    fcode_error = 0;      
    otherwise
    fcode_error = 1;
end

end

