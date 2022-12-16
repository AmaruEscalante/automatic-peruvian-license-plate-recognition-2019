function [height,width, pos, center] = characteristics(BoundaryOfCharacter)
% This function extracts the characteristics of the boundary of an image
% finds the height, width, one point of the contour to draw a rectangle
% around the image and the center of the point.
character = BoundaryOfCharacter;
height = max(character(:,1)) - min(character(:,1));
width = max(character(:,2)) - min(character(:,2));
pos = [min(character(:,2)) min(character(:,1))];
center = pos + round([width/2 height/2]);
end

