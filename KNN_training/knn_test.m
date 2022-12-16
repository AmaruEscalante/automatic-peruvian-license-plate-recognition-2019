clearvars; close all; clc;
load CharacterRecognition

RESIZED_HEIGHT = 30;
RESIZED_WIDTH = 20;

I = imread('training_chars.png');
I = rgb2gray(I);
h = imgaussfilt(I, 1.3);
% Adaptative Thresholding
T = adaptthresh(h,0.56,'NeighborhoodSize',[5 5],'ForegroundPolarity','dark','Statistic','gaussian'); 

BW = imbinarize(I,T);
BW = 1-BW;

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