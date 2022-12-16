clearvars; close all; clc;
%load CharacterRecognition
load modelmodified
RESIZED_HEIGHT = 48;
RESIZED_WIDTH = 20;
I = imread('Test_plates/i4_c.png');
%I = imread('1.png');
I = rgb2gray(I);
%% Maximize contrast through morphological operations
SE = strel('rectangle', [3 3]);

% Top HAT
TH = imtophat(I,SE);%Opens the image -First Erodes, Dilutes
% Black HAT
BH = imbothat(I,SE);
% Enhance Image by Adding TopHat aond Grayscale Image
EN = TH + I;
figure; imshow(EN); title('Enhanced Image');
% Substracting BlackHat from Enhanced Image
Sub_en = EN-BH;
figure; imshow(Sub_en); title('Substracted Image');
%%
h = obtenerPlaca(Sub_en); % More PreProcessing and Crop Plate

% Gaussian filtering
h = imgaussfilt(h, 1.01);
figure;
imshow(h); title('Gaussian filtered Image');
% Adaptative Thresholding (Gaussian)
T = adaptthresh(h,0.53,'NeighborhoodSize',[19 19],'ForegroundPolarity','dark','Statistic','gaussian'); 
BW = imbinarize(h,T);
BW =logical(1-BW);
figure;
imshow(BW); title('Thresholded Image');



%% Detect Characters
BW = bwareafilt(BW,[70 1100]);
[L, Ne]=bwlabeln(BW);
value = zeros(1,length(Ne));

propied=regionprops(L,'BoundingBox');

figure; imshow(BW);
hold on;
%%
for n = 1:Ne
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end

for n = 1:Ne
    [r,c] = find(L==n); % Contours of each bounding box
    ROI = BW(min(r):max(r),min(c):max(c)); % Cut the ROI with the dimensions of each bounding box
    ROI = uint8(mat2gray(ROI)*255);
    ROI_resize = imresize(ROI, [RESIZED_HEIGHT, RESIZED_WIDTH]);
    flatt = double(ROI_resize(:)');
    
    % Plottin for guidance
    figure; subplot(121);
    imshow(ROI);
    title('Segmented Characters');
    subplot(122);
    imshow(ROI_resize); title('Resized ROI');
    
    charClass = predict(Mdl,flatt);
    recognized_char = char(charClass);
    message = sprintf('Recognized character is : %s', recognized_char);
    disp(message)
end
