function Y = medfiltRGB(I,m)
Y = zeros(size(I),'uint8');
for i = 1:3
    Y(:,:,i) = uint8(medfilt2(I(:,:,i),[m m]));
end
end