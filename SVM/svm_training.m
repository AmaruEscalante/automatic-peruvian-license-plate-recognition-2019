close all; clc; clearvars;
load sortedvars
%%
%class_sorted = sort(Y);
%vars = [classifications flattened_images];
% Order matrix by one specific column
%[~,idx] = sort(sortedvars(:,1)); % sort just the first column
%sortedvars = sortedvars(idx,:);   % sort the whole matrix using the sort indices

images = sortedvars(:,2:end); % Load images
classes = sortedvars(:,1); % Load classes
SVMModels{36,1} = []; 
%% Train models
for k = 1:35
    if k == 1
        n_class = classes;
        n_images = images;
    else
        n_class = classes((k-1)*5+1:end);
        n_images = images((k-1)*5+1:end,:);
    end

    if k == 35
        n_class(6:end) = 90;
    else
        n_class(6:end) = 45;
    end
    class_names{k} = char(n_class);
    seg_images{k} = n_images;
    SVMModels{k} = fitcsvm(seg_images{k},class_names{k});
end
%%
char1 = images(1,:);
tic
for k = 1:36
    char = predict(SVMModels{k},char1);    
    if strcmp(char,'-') == 0
        break
    end        
end
toc
disp(char)


