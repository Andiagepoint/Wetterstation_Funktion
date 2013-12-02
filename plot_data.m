function [ x, y ] = plot_data( prog ,cell_array )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
x = [];
y = [];
for s = 5:2:size(cell_array,2)
    x = [x,cell_array{prog,s}];
    y = [y,cell_array{prog,s+1}];
end
stem(x,y);
h = gcf;
a = gca;
set(a,'YLim',[min(y)-10,max(y)+10]);
end

