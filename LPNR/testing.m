clearvars; close all; clc;
test_plates = ["F8N515", "V6X717","F3W678", "BID410","ACU530", "F8N515","T3X141", "B6C329", ...
               "AJN142","ALH618","B7B312","BJB008","AWE331"];
%%
%figure;imshow(I);
%%
for k= 1:10
    I = imread(sprintf('Test_plates3/i%01d.png',k));
tic
    plate1{k} = plate_recognition(I,'1',0);
toc
tic
    plate2{k} = plate_recognition(I,'2',0);
toc
tic
    plate3{k} = plate_recognition(I,'3',0);
toc
tic
    plate4{k} = plate_recognition(I,'4',0);
toc
tic
    plate5{k} = plate_recognition(I,'5',0); % SVMMulticlass Optimized
toc

end
%%
for k= 11:19
    I = imread(sprintf('Test_plates3/i%01d.jpg',k));

    plate1{k} = plate_recognition(I,'1',0); % KNN 

    plate2{k} = plate_recognition(I,'2',0); % KNN Optimized

    plate3{k} = plate_recognition(I,'3',0); % SVMMulticlass
   
    plate4{k} = plate_recognition(I,'4',0); % SVM Tree
    
    plate5{k} = plate_recognition(I,'5',0); % SVMMulticlass Optimized
end
%%
for i = 1:19
    plate3{i} = char(plate3{i});
    plate5{i} = char(plate5{i})
end
%%
%save p5 plate5
%save p4 plate4
%save p3 plate3
%save p2 plate2
%save p1 plate1








