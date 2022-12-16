%% Read Image
clearvars; close all; clc;
I = imread('Test_plates3/i6.png');
%I = imread('Test_plates2/i (14).jpg');
I = rgb2gray(I);
% Enhance contrast

%I = imread('LicPlateImages/5.png');
% Detect Plates in Scene
%N = uint8(scale(N));

steps = 1; % steps 0 to not show
nomatches = 0;
if steps == 1
    figure; imshow(I); title('Original Image');
    %figure; imshow(N); title('Gamma Image'); colormap gray;
    %figure; imhist(N); title('Histogram');
end

%% Preprocessing
% Maximize contrast through morphological operations
SE = strel('rectangle', [3 3]);
% Top HAT
TH = imtophat(I,SE);%Opens the image -First Erodes, Dilutes
% Black HAT
BH = imbothat(I,SE);
% Enhance Image by Adding TopHat aond Grayscale Image
EN = TH + I;
% Substracting Black Hat Image
Sub_en = EN-BH;
h = imgaussfilt(Sub_en,'FilterSize',5);

% Adaptative Thresholding (Gaussian)
T = adaptthresh(h,0.40,'NeighborhoodSize',[19 19],'ForegroundPolarity','dark','Statistic','gaussian'); 
BW = imbinarize(h,T);
BW = logical(1-BW);

if steps == 1
    figure; imshow(Sub_en); title('Substracted Image');
    figure; imshow(h); title('Gaussian filtered Image');
    figure; imshow(BW); title('Thresholded Image');
end

%% Find Possible Chars on image

%% Finding boundaries
B_edges = edge(BW, 'canny', 0.7);
if steps == 1
    figure;
    imshow(B_edges); title('Edges');
end
[B, L, n, A]= bwboundaries(B_edges);

[row,col] = size(I);
zeromatrix = logical(zeros(row,col));
if steps == 1
    figure;
    imshow(zeromatrix);title('boundaries'); hold on;
end
count = 0;

MIN_HEIGHT = 8;
MIN_WIDTH = 2;
MIN_ASPECT_RATIO = 0.25;
MAX_ASPECT_RATIO = 1;
MIN_PIX_AREA = 80;

for k=1:length(B)
   boundary = B{k};
   height = max(boundary(:,1)) - min(boundary(:,1));
   width = max(boundary(:,2)) - min(boundary(:,2));
   aspect_ratio = width/height;
   area = height*width;
   if(k < n)
       if steps == 1
            plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
       end
     % Selects the contours, so they meet the minimun requirements that a
     % license plate character has: ASPECT RATIO, AREA, WIDTH, HEIGHT
     if (height >= MIN_HEIGHT) && (width >= MIN_WIDTH) && (area >= MIN_PIX_AREA) && ...
        (aspect_ratio>=MIN_ASPECT_RATIO) && (aspect_ratio<=MAX_ASPECT_RATIO)
         count = count +1;
         possible_characters{count} = boundary;
         if steps == 1
            plot(boundary(:,2), boundary(:,1), 'r','LineWidth',1);
         end
     end
   end
end

%% Find list of matching Characters
% In this part, each possible character is compared with the big list of
% possible characters from the previous step and if there is a match
% between them a list is retrieved.

% Thresholds for finding possible characters
MAX_DIAG_SIZE_MULTIPLE_AWAY = 5.0;
MAX_ANGLE_BETWEEN_CHARS = 12.0;
MAX_CHANGE_IN_AREA = 0.3;
MAX_CHANGE_IN_WIDTH = 0.3;
MAX_CHANGE_IN_HEIGHT = 0.2;


listofpossiblechars = {};
if steps == 1
    figure;
    imshow(I);title('Lists of Matching Characters'); hold on;
end
i = 1; j = 1;x = 0;
for n = 1:length(possible_characters)
    character = possible_characters{n};
    % Characteristics of the boundary of the character: height, width, 
    % position, center
    [h,w,p,c] = characteristics(character);
    area = h*w;
    if steps == 1
        rectangle('Position',[p w h],'EdgeColor','g','LineWidth',2)
    end
    %scatter(c(1),c(2),'r','LineWidth',1); %Draw a circle on the middle of
    %the rectangle
    x = 0;
    for k = 1:length(possible_characters)
        comp_char = possible_characters{k};
        [hc,wc,pc,cc] = characteristics(comp_char);
        area_c = hc*wc;
        if cc == c
            continue
        end
        diff = abs(c - cc);
        dist = sqrt(diff(1)^2 + diff(2)^2);
        if diff(1) ~= 0 % This is made to avoid division by 0 if the 
                        % possible character is compared with other character in the same X position
            angle = atan(double(abs(diff(2)/diff(1))));
        else
            angle = 1.5708;
        end        
        angle_deg = angle*180.0/pi;
        change_area = double(abs((area - area_c)/area));
        change_width = double(abs(((w-wc)/w)));
        change_height = double(abs((h-hc)/h));
        diag_size = double(sqrt(wc^2 + hc^2));
        % Save previous listofpossiblecharacters
        prev_list = listofpossiblechars;
        if steps == 1
            hrec = rectangle('Position',[pc wc hc],'EdgeColor','y','LineWidth',2);
        end
        % Compare possible characters to find relations in angle, height,
        % area, to order them in a common array
        if (dist < (diag_size*MAX_DIAG_SIZE_MULTIPLE_AWAY)) && (angle_deg < MAX_ANGLE_BETWEEN_CHARS)...
            && (change_area < MAX_CHANGE_IN_AREA) && (change_width<MAX_CHANGE_IN_AREA) && (change_height< MAX_CHANGE_IN_HEIGHT)
            list = comp_char; 
            % Here the groups of possible characters are saved
            listofpossiblechars{j,i} = list;
            [h,w,p,c] = characteristics(list);
            if steps == 1
                rectangle('Position',[p w h],'EdgeColor','y','LineWidth',2);
            end
            i = i+1;
            x = x+1;
        else
            if steps == 1
                delete(hrec);
            end
        end
        
    end
    if (isempty(listofpossiblechars) ~= 1) && (x ~=0)
        j = j+1;
        i = 1;
    end
end
%% FIND NUMBER OF MATCHING PLATES
MIN_NUMBER_OF_MATCHING_CHARACTERS = 6;
list_chars = listofpossiblechars; 
i = 1;
matches = {};
for k = 1:length(list_chars(:,1))
    val = list_chars(k,:);
    simp = val(~cellfun('isempty',val));
    if length(simp) >= MIN_NUMBER_OF_MATCHING_CHARACTERS
        matches{i} = simp;
        i = i+1;
    end
end
if isempty(matches) == 1
    disp('no matches found');
    nomatches = 1;
else
    num = length(matches);
    message = [num2str(num), ' plates found'];
    disp(message);
    nomatches = 0;
end

%% EXTRACT MATCHES
if nomatches ~= 1

if steps == 1
    figure;
    imshow(I);
    hold on;
end
for k = 1:length(matches)
    group = matches{k};
    for j = 1:length(group)
       chars = group{j}; 
       [h,w,p,c] = characteristics(chars);
       if steps == 1
            rectangle('Position',[p w h],'EdgeColor','y','LineWidth',2)
       end
    end
end

for n = 1:length(listofpossiblechars(:,1))
    group = listofpossiblechars{n,:};
    [h,w,p,c] = characteristics(group);
    if steps == 1
        rectangle('Position',[p w h],'EdgeColor','y','LineWidth',2)
    end
end
disp('finished');
%% Sorts matches in descending order so the first one is the largest group
[R,Im] = sort(cellfun('length',matches),'descend');
ord_matches = matches(Im);

if steps ==1
figure;
imshow(BW);
hold on;
end

match = ord_matches{1};



%% Character Recognition
RESIZED_HEIGHT = 48;
RESIZED_WIDTH = 20;

load KNNMdl
KNNMdl = KNNMdl;
load OptKNNMdl
OptKNNMdl = OptKNNMdl;
load svmModel
SVMMdl = svmMdl; %Multiple Class SVM

for k = 1:length(match)
    val = match{k};
    [h,w,p,c] = characteristics(val);
    
    if steps == 1
            rectangle('Position',[p w h],'EdgeColor','b','LineWidth',2);
    end
    
    ROI = BW(p(2):p(2)+h,p(1):p(1)+w); % Crop characters from Thresholded image
    ROI = uint8(mat2gray(ROI)*255);
    ROI_resize = imresize(ROI, [RESIZED_HEIGHT, RESIZED_WIDTH]);
    flatt = double(ROI_resize(:)');
    images{k} = ROI_resize;
    if steps == 1
        % Plotting for guidance
        figure; subplot(121);
        imshow(ROI);
        title('Segmented Characters');
        subplot(122);
        imshow(ROI_resize); title('Resized ROI');
    end
    
    % Recognition
    charClass1 = predict(KNNMdl,flatt);
    charClass2 = predict(OptKNNMdl,flatt);
    charClass3 = predict(SVMMdl,flatt);
    plate1(k) = charClass1;
    plate2(k) = charClass2;
    plate3(k) = charClass3;
    %message = sprintf('Recognized character is : %s', recognized_char);
    %disp(message)
end
else
    disp('0 detected characters');
    plate1 = [];
    plate2 = [];
    plate3 = [];
end

message1 = sprintf('KNN: %s', plate1);
message2 = sprintf('OptKNN: %s', plate2);
message3 = sprintf('M-SVM: %s', plate3);

disp(message1)
disp(message2)
disp(message3)