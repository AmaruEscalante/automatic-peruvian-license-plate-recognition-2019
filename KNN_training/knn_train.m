clearvars; close all; clc;

RESIZED_HEIGHT = 48;
RESIZED_WIDTH = 20;

I = imread('training_chars.png');
I = rgb2gray(I);

% Gaussian filter is used to remove noise
h = imgaussfilt(I, 1.3);

figure;subplot(121);imagesc(I); title('Original Image');
subplot(122);imagesc(h);title('Gaussian filtered Image'); colormap gray; truesize;
%% Adaptative Thresholding
T = adaptthresh(h,0.56,'NeighborhoodSize',[5 5],'ForegroundPolarity','dark','Statistic','gaussian'); 

BW = imbinarize(I,T);
figure;
imshow(BW);title('Binarized image');

%Discard regions with areas with less than 30 pixels
%BW = bwareaopen(BW,30);

BW = 1-BW; %Image is inverted, because the function regionprops only 
           %recognizes white elements over black background
figure;
imshow(BW);title('Inverted binarized image');

% Label connected components
[L, Ne]=bwlabeln(BW);

% Measure properties of image regions
value = zeros(1,length(Ne)); % Prellocate space

propied=regionprops(L,'BoundingBox');
 hold on;

intValidChars = [int8('0'), int8('1'), int8('2'), int8('3'), int8('4'), int8('5'), int8('6'), int8('7'), int8('8'), int8('9')...
                 int8('A'), int8('B'), int8('C'), int8('D'), int8('E'), int8('F'), int8('G'), int8('H'), int8('I'), int8('J')...
                 int8('K'), int8('L'), int8('M'), int8('N'), int8('O'), int8('P'), int8('Q'), int8('R'), int8('S'), int8('T')...
                 int8('U'), int8('V'), int8('W'), int8('X'), int8('Y'), int8('Z')];
             
% Plot Bounding Box
flattened_images = zeros(size(propied,1), RESIZED_HEIGHT*RESIZED_WIDTH);
classifications = zeros(size(propied,1),1);

for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    
    [r,c] = find(L==n); % Contours of each bounding box
    ROI=BW(min(r):max(r),min(c):max(c)); % Cut the ROI with the dimensions of each bounding box
    ROI = uint8(mat2gray(ROI)*255);
    ROI_resize = imresize(ROI, [RESIZED_HEIGHT, RESIZED_WIDTH]);
    
    % Plotting for trainning guidance
    figure; subplot(121);
    imshow(ROI);
    title('Segmented Characters');
    subplot(122);
    imshow(ROI_resize); title('Resized ROI');
    
    % Waits for keystroke to store the recognized value in a set of data
    waitforbuttonpress
    
    character = double(get(gcf,'CurrentCharacter'));
    if character == 27 % Exit 
        close all;
        return        
    elseif sum(character == intValidChars)>=1
        % If the value is in the list, the ROI is stored
        value(n) = character;
        vector = ROI_resize(:);
        flattened_images(n,:) = vector';
        classifications(n,1) = character;
    end    
    close;
end

disp("Recognized Characters");
disp(value);
%% Training K-Nearest Neigbors
load sortedvars
flat_image = sortedvars(:,2:end); % Load images
class = char(sortedvars(:,1)); % Load classes

KNNMdl = fitcknn(flat_image,class,'NumNeighbors',1,'Standardize',1);

rng(1)
OptKNNMdl = fitcknn(flat_image,class,'OptimizeHyperparameters','auto',...
                    'HyperparameterOptimizationOptions',...
                    struct('AcquisitionFunctionName','expected-improvement-plus'));
%%
for i = 1:180
    char1 = flat_image(i,:); % an average flower
    charClass = predict(KNNMdl,char1);
    recognized_char = char(charClass);
    message = sprintf('Recognized character is : %s', recognized_char);
    disp(message)
end

%%
save OptKNNMdl OptKNNMdl
save KNNMdl KNNMdl




