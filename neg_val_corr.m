function [ corr_values ] = neg_val_corr( fc_def, edindex, int_val, unix_t_mean )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if strcmp(fc_def,'solarleistung') == 1 && edindex == 1
    tempx = unix_t_mean;
    temp1 = tempx <= sun_rise_today;
    temp2 = tempx > sun_rise_today & tempx < sun_set_today;
    temp3 = tempx >= sun_set_today;
    tempy = int_val;
    tempy1 = tempy(temp1);
    tempy2 = tempy(temp2);
    tempy3 = tempy(temp3);
    tempy1(tempy1<0) = 0;
    tempy1(tempy1>0) = 0;
    tempy2(tempy2<0) = 0;
    tempy3(tempy3<0) = 0;
    tempy3(tempy3>0) = 0;
    corr_values = [tempy1 tempy2 tempy3];
elseif strcmp(fc_def,'solarleistung') == 1 && edindex == 2
    tempx = unix_t_mean;
    temp1 = tempx <= sun_rise_today;
    temp2 = tempx > sun_rise_today & tempx < sun_set_today;
    temp3 = tempx >= sun_set_today & tempx <= sun_rise_tomorrow;
    temp4 = tempx > sun_rise_tomorrow & tempx < sun_set_tomorrow;
    temp5 = tempx >= sun_set_tomorrow;
    tempy = int_val;
    tempy1 = tempy(temp1);
    tempy2 = tempy(temp2);
    tempy3 = tempy(temp3);
    tempy4 = tempy(temp4);
    tempy5 = tempy(temp5);
    tempy1(tempy1<0) = 0;
    tempy1(tempy1>0) = 0;
    tempy2(tempy2<0) = 0;
    tempy3(tempy3<0) = 0;
    tempy3(tempy3>0) = 0;
    tempy4(tempy4<0) = 0;
    tempy5(tempy5<0) = 0;
    tempy5(tempy5>0) = 0;
    corr_values = [tempy1 tempy2 tempy3 tempy4 tempy5];
elseif strcmp(fc_def,'menge') == 1 || strcmp(fc_def,'straerke') == 1
    temp = int_val;
    temp(temp < 0) = 0;
    corr_values = temp;
end

end

