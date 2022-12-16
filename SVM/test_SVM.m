clearvars; close all; clc;
load treeSVM
load sortedvars
SVMMdl = SVMModels;
flat_image = sortedvars(:,2:end); % Load images
class = char(sortedvars(:,1)); % Load classes

for i = 180:-1:1
    char1 = flat_image(i,:); % an average flower
    charClass = predictSVM(SVMMdl,char1);
    recognized_char = char(charClass);
    message = sprintf('Recognized character is : %s', recognized_char);
    disp(message)
end