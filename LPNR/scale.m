function [f] = scale(I)
%SCALE Summary of this function goes here
%   Detailed explanation goes here
f = I - min(min(I));
f = 255*(f/max(max(f)));
end

