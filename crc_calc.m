function [ txdata_hex ] = crc_calc( modbus_pud_hex )
%This function calculates the cyclic redundancy check value. Its input
%are the message bytes in hexadecimal format, i.e. 01010000000A
%   Detailed explanation goes here

%Determine the number of bits the given message has
databits = size(modbus_pud_hex,2)*4;

%Convert the hexadecimal input into a binary format
datastream = hexToBinaryVector(modbus_pud_hex,databits);

%Define the shiftregister 
CRCshiftreg_bin = hexToBinaryVector('FFFF',16);

%Define the generator polynom 
CRCgenpolynom_bin = hexToBinaryVector('A001',16);

%Define check bit-mask 
checkbitmask_bin = hexToBinaryVector('0001',16);

%Extract byte by byte from datastream and represent it as a 16bit word
n = 8;
m = 1;
for s = 1 : ceil(size(modbus_pud_hex,2)/2)
    data_byte = datastream(1,m:n);
    data_16bit = logical([zeros(1,8) data_byte]);
    crc_erg = xor(data_16bit,CRCshiftreg_bin);
    for t = 1 : 8
        if crc_erg(1,end) == 0
            crc_erg = logical([0 crc_erg(1,1:end-1)]);
        else
            crc_erg = xor(logical([0 crc_erg(1,1:end-1)]),CRCgenpolynom_bin);
        end
    end
    CRCshiftreg_bin = crc_erg;
    m = m + 8;
    n = n + 8;
end
if bin2dec(sprintf('%i',CRCshiftreg_bin)) < 256
    txdata_lbyte = dec2hex(bin2dec(sprintf('%i',CRCshiftreg_bin)));
    txdata_hbyte = '00';
    crc_16 = strcat(txdata_lbyte,txdata_hbyte);
else
    txdata_byte = dec2hex(bin2dec(sprintf('%i',CRCshiftreg_bin)));
    if size(txdata_byte,2) == 3
        txdata_byte = strcat('0', txdata_byte);
        crc_16 = strcat(txdata_byte(1,3:4),txdata_byte(1,1:2));
    else
        crc_16 = strcat(txdata_byte(1,3:4),txdata_byte(1,1:2));
    end
end
txdata_hex = strcat(modbus_pud_hex,crc_16);
end

