function [ x, y ] = lpd( data, bereich )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
for t = 1:size(data.(bereich),1)
   x(t) = double(cell2mat(data.(bereich){t}(4)));
   y(t) = cell2mat(data.(bereich){t}(2));
    
end

end

