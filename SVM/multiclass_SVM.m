close all; clc; clearvars;
load sortedvars

images = sortedvars(:,2:end); % Load images
classes = sortedvars(:,1); % Load classes

rng default
Mdl = fitcecoc(images,classes,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'));