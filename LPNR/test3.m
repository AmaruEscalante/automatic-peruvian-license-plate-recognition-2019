close all
clearvars
clc

m = 3; % for median

%% i3
I = imread('i3 copy.png');
Isharp = sharpRGB(I);
Imedian = medfiltRGB(Isharp,m);
figure;
subplot(1,3,1);
imagesc(I); axis('image'); colorbar;
subplot(1,3,2);
imagesc(Isharp); axis('image'); colorbar;
subplot(1,3,3);
imagesc(Imedian); axis('image'); colorbar;
imwrite(Isharp,'newI3.jpg','jpeg','Quality',100);
imwrite(Imedian,'newI3median.jpg','jpeg','Quality',100);

%% i2
I = imread('i2 copy.png');
Isharp = sharpRGB(I);
Imedian = medfiltRGB(Isharp,m);
figure;
subplot(1,3,1);
imagesc(I); axis('image'); colorbar;
subplot(1,3,2);
imagesc(Isharp); axis('image'); colorbar;
subplot(1,3,3);
imagesc(Imedian); axis('image'); colorbar;
imwrite(Isharp,'newI2.jpg','jpeg','Quality',100);
imwrite(Imedian,'newI2median.jpg','jpeg','Quality',100);

%% i8
I = imread('i8 copy.png');
Isharp = sharpRGB(I);
Imedian = medfiltRGB(Isharp,m);
figure;
subplot(1,3,1);
imagesc(I); axis('image'); colorbar;
subplot(1,3,2);
imagesc(Isharp); axis('image'); colorbar;
subplot(1,3,3);
imagesc(Imedian); axis('image'); colorbar;
imwrite(Isharp,'newI8.jpg','jpeg','Quality',100);
imwrite(Imedian,'newI8median.jpg','jpeg','Quality',100);
