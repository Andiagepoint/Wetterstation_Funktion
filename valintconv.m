function [  ] = valintconv( factor_r, factor_t, table, new_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for t = 1:18
   s = regexp(table{t},'-','split');
   new_data.(s{1}).(s{2}).int_val = [];
   new_data.(s{1}).(s{2}).unix_t_mean = [];
   for u = 1:size(new_data.(s{1}).(s{2}).org_val,2)
   new_data.(s{1}).(s{2}).int_val(u) = new_data.(s{1}).(s{2}).org_val(u);
   end
   if strcmp(s{1},'niederschlag') == 1 || strcmp(s{1},'luftdruck') == 1 || strcmp(s{1},'solarleistung') == 1 || strcmp(s{1},'temperatur') == 1 || strcmp(s{2},'staerke') == 1
   if strcmp(s{2},'mittlere_temp_prog') == 1
   new_data.(s{1}).(s{2}).unix_t_strt = new_data.(s{1}).(s{2}).unix_t_strt(1:factor_t:end);
   new_data.(s{1}).(s{2}).unix_t_end = new_data.(s{1}).(s{2}).unix_t_end(1:factor_t:end);
   new_data.(s{1}).(s{2}).unix_t_rec = new_data.(s{1}).(s{2}).unix_t_rec(1:factor_t:end);
   else
   new_data.(s{1}).(s{2}).unix_t_strt = new_data.(s{1}).(s{2}).unix_t_strt(1:factor_r:end);
   new_data.(s{1}).(s{2}).unix_t_end = new_data.(s{1}).(s{2}).unix_t_end(1:factor_r:end);
   new_data.(s{1}).(s{2}).unix_t_rec = new_data.(s{1}).(s{2}).unix_t_rec(1:factor_r:end);     
   end
   end
end
assignin('base','new_data',new_data);
end

