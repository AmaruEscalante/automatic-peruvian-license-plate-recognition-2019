clearvars; close all; clc;
load p1
load p2
load p3
load p4
load p5

test_plates = ['V6X717';'F3W678';'B1D410';'ACU530';'F8N515';'B6C329'; ...
               'ALH618';'B7B312';'BJB008';'AWE331';'BJN652';'AZW158'; ...
               'F0S029';'F3C175';'AFC511';'B6L329';'ADI452';'F7C080';'BAQ699'];

% Pick only 6 characters
%plate = [plate1;plate2;plate3;plate4;plate5];
plate = [plate1;plate2;plate3];


%% Select only the first 6 characters 
for j = 1:size(plate,1)
    for k = 1:length(plate)
        plt = plate{j,k};   
        if length(plate{j,k})>6
            plate{j,k} = plt(1:6);
        end
    end
end
%% Errors per model
for j=1:size(plate,1)
    for k=1:length(plate)
        plt_cmp = plate{j,k};
        for i = 1:length(plate{j,k})
            comp(i) = strcmp(test_plates(k,i),plt_cmp(i));
        end
        error{j,k} = comp;
    end
end
%% Find number of occurences of characters on the list of Test plates
alphanumeric = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'...
                 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'...
                 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'...
                 'U', 'V', 'W', 'X', 'Y', 'Z'];

num_char = zeros(36,1);
for i = 1:length(alphanumeric)
    plt = test_plates(:)';
    num_char(i,:) = length(strfind(plt,alphanumeric(i)));
end

%% Find Number of Matching Chars by Model
% MODEL 1 - KNN
% MODEL 2 - KNN-Opt
% MODEL 3 - SVM MULTI
% MODEL 4 - SVM Tree
% Iterates through each alphanumerig digit
for i = 1:length(alphanumeric)
    %Iterates over the 4 license plate models
    for j = 1:size(plate,1)
        %Iterates over the 19 license plate recognized for each model
        for k = 1:length(plate)
            plt = plate{j,k};
            err = error{j,k};
            plt_new{j,k} = char(plt.*double(err));
            plt_cmp = plt_new{j,k};
            char_count(k) = length(strfind(plt_cmp,alphanumeric(i)));
        end
        char_count_mdl{i,j} = sum(char_count);
    end
end

 %% Stores missing matches
 % Iterates through each alphanumerig digit
for i = 1:length(alphanumeric)
    %Iterates over the 4 license plate models
    for j = 1:size(plate,1)
        %Iterates over the 19 license plates recognized for each model
        for k = 1:length(plate)
            plt = plate{j,k};
            plt_test = test_plates(k,:);
            err = error{j,k};
            plt_err{j,k} = char(plt.*double(1-err));
            plt_true{j,k} = char(plt_test.*double(1-err));
            plt_cmp = plt_err{j,k};
            plt_real = plt_true{j,k};         
            if contains(plt_real,alphanumeric(i))
                plt_res = plt_cmp(plt_real==alphanumeric(i));
                if length(plt_res)>1
                    for l = 1:length(plt_res)
                        char_store(l) = plt_res(l);                    
                    end
                else
                char_store(k) = plt_res;
                end
            end
        end
        char_error_count_mdl{i,j} = char_store;
        char_store = '';
    end
end
%% Plot Table of Errors
% Make the tables
characters = alphanumeric';
count = num_char;
models = char_count_mdl;
miss_char = char_error_count_mdl;
T = table(characters, count, models, miss_char);




