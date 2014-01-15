function [  ] = dpsimul( old_w_dat, new_dat, table, flag, flag_struct )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if flag_struct == 1
nwd = load(new_dat);
if flag == 1
owd = load(old_w_dat);
weather_data = [];
end
owd = load(old_w_dat);

new_data = [];
for z = 1:size(table,1)
    if flag == 1
        weather_data = create_data_struct(table{z}, weather_data, 'weather_data');
    end
        new_data = create_data_struct(table{z}, new_data, 'new_data');
end
e=1;
for t = 1:size(table,1)
    l = 1;
    s = regexp(table{t},'-','split');
    
    while strcmp(owd.new_data{e,2},owd.new_data{e+1,2}) == 1
        if flag == 1
<<<<<<< HEAD
        weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5};
        weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6};
        weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
        weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
        weather_data.(s{1}).(s{2}).interval_t_clr{l} = {[' ',utc2date(owd.new_data{e,5}),'-',datestr(utc2date(owd.new_data{e,6}),13)]};
        weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
        weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
=======
        weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5}-1;
        weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6}-1;
        weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
        weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
        temp = [cell2mat(utc2date(owd.new_data{e,5})),'-',datestr(utc2date(owd.new_data{e,6}),13)];
        weather_data.(s{1}).(s{2}).interval_t_clr{l} = {temp};
        weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
        weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
        weather_data.(s{1}).(s{2}).org_unix_t_strt(l) = owd.new_data{e,5}-1;
        weather_data.(s{1}).(s{2}).org_unix_t_end(l) = owd.new_data{e,6}-1;
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
        end
        if size(nwd.new_data,2) < 8 
        new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,1};
        new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,2};
        new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,3}-nwd.new_data{e,2})/2)+nwd.new_data{e,2};
        new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,3};
        new_data.(s{1}).(s{2}).interval_t_clr{l} = [];
        new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,4};
        new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,4};
<<<<<<< HEAD
=======
        new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,1};
                new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,2};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
        else
        new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,5};
        new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,6};
        new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,6}-nwd.new_data{e,5})/2)+nwd.new_data{e,5};
        new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,7};
        new_data.(s{1}).(s{2}).interval_t_clr{l} = nwd.new_data{e,4};
        new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,8};
        new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,8};
<<<<<<< HEAD
=======
        new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,5};
        new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,6};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
        end

           l = l+1;

           e = e+1;
           if e >= size(nwd.new_data,1)
               if flag == 1
<<<<<<< HEAD
                weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6};
                weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
                weather_data.(s{1}).(s{2}).interval_t_clr{l} = {[' ',utc2date(owd.new_data{e,5}),'-',datestr(utc2date(owd.new_data{e,6}),13)]};
                weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
=======
                weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5}-1;
                weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6}-1;
                weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
                temp = [cell2mat(utc2date(owd.new_data{e,5})),'-',datestr(utc2date(owd.new_data{e,6}),13)];
                weather_data.(s{1}).(s{2}).interval_t_clr{l} = {temp};
                weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).org_unix_t_strt(l) = owd.new_data{e,5}-1;
                weather_data.(s{1}).(s{2}).org_unix_t_end(l) = owd.new_data{e,6}-1;
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
               end
                if size(nwd.new_data,2) < 8 
                new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,1};
                new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,2};
                new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,3}-nwd.new_data{e,2})/2)+nwd.new_data{e,2};
                new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,3};
                new_data.(s{1}).(s{2}).interval_t_clr{l} = [];
                new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,4};
                new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,4};
<<<<<<< HEAD
=======
                new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,1};
                new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,2};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
                else
                new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,6};
                new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,6}-nwd.new_data{e,5})/2)+nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,7};
                new_data.(s{1}).(s{2}).interval_t_clr{l} = nwd.new_data{e,4};
                new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,8};
                new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,8};
<<<<<<< HEAD
=======
                new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,6};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
                end
               break;
           end
           if strcmp(owd.new_data{e,2},owd.new_data{e+1,2}) ~= 1
                if flag == 1
<<<<<<< HEAD
                weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6};
                weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
                weather_data.(s{1}).(s{2}).interval_t_clr{l} = {[' ',utc2date(owd.new_data{e,5}),'-',datestr(utc2date(owd.new_data{e,6}),13)]};
                weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
=======
                weather_data.(s{1}).(s{2}).unix_t_strt(l) = owd.new_data{e,5}-1;
                weather_data.(s{1}).(s{2}).unix_t_end(l) = owd.new_data{e,6}-1;
                weather_data.(s{1}).(s{2}).unix_t_mean(l) = floor((owd.new_data{e,6}-owd.new_data{e,5})/2)+owd.new_data{e,5};
                weather_data.(s{1}).(s{2}).unix_t_rec(l) = owd.new_data{e,7};
                temp = [cell2mat(utc2date(owd.new_data{e,5})),'-',datestr(utc2date(owd.new_data{e,6}),13)];
                weather_data.(s{1}).(s{2}).interval_t_clr{l} = {temp};
                weather_data.(s{1}).(s{2}).org_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).int_val(l) = owd.new_data{e,8};
                weather_data.(s{1}).(s{2}).org_unix_t_strt(l) = owd.new_data{e,5}-1;
                weather_data.(s{1}).(s{2}).org_unix_t_end(l) = owd.new_data{e,6}-1;
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
                end 
                if size(nwd.new_data,2) < 8 
                new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,1};
                new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,2};
                new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,3}-nwd.new_data{e,2})/2)+nwd.new_data{e,2};
                new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,3};
                new_data.(s{1}).(s{2}).interval_t_clr{l} = [];
                new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,4};
                new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,4};
<<<<<<< HEAD
=======
                new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,1};
                new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,2};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
                else
                new_data.(s{1}).(s{2}).unix_t_strt(l) = nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).unix_t_end(l) = nwd.new_data{e,6};
                new_data.(s{1}).(s{2}).unix_t_mean(l) = floor((nwd.new_data{e,6}-nwd.new_data{e,5})/2)+nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).unix_t_rec(l) = nwd.new_data{e,7};
                new_data.(s{1}).(s{2}).interval_t_clr{l} = nwd.new_data{e,4};
                new_data.(s{1}).(s{2}).org_val(l) = nwd.new_data{e,8};
                new_data.(s{1}).(s{2}).int_val(l) = nwd.new_data{e,8};
<<<<<<< HEAD
=======
                new_data.(s{1}).(s{2}).org_unix_t_strt(l) = nwd.new_data{e,5};
                new_data.(s{1}).(s{2}).org_unix_t_end(l) = nwd.new_data{e,6};
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
                end
                e = e + 1;
               break;
           end
    end
end
if flag == 1
    assignin('base','weather_data',weather_data);
end
assignin('base','new_data',new_data);
% switch size(nd.weather_data.temperatur.min.int_val,1)
%     case 1152
%         res = 0.08;
%     case 384
%         res = 0.25;
%     case 192
%         res = 0.5;
% end
% 
end
new_data = evalin('base','new_data');
timestamp = regexp(new_dat,'_','split');
if flag == 1
<<<<<<< HEAD
daychange = 0;
assignin('base','daychange',daychange);
=======
daychange_flag = 0;
daychange_counter = 0;
assignin('base','daychange_flag',daychange_flag);
assignin('base','daychange_counter',daychange_counter);
>>>>>>> 58edc4e4bef1bcaa889b8ec51ab0e7e38011a2d0
end
% timestamp = regexp(timestamp(1,end),'[.]','split');
timestamp = str2double(timestamp{4});
assignin('base','timestamp',timestamp);
% qual = nd.weather_data.temperatur.min.con_qual(1);
for t = 1:size(table,1)
    s = regexp(table{t},'-','split');
    qual = 9;
dpsim(new_data.(s{1}).(s{2}).org_val,table{t},0.08,1,qual)
end
end

