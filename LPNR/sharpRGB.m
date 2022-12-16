%%
function Y = sharpRGB(I)
Y = zeros(size(I),'uint8');
for i = 1:3
    Y(:,:,i) = uint8(imsharpen(I(:,:,i),'Radius',2,'Amount',5));
end
end