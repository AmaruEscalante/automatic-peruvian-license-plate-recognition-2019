function char = predictSVM(SVMModel_cell, image)
% How to use
% Load SVMModel cell with: load treeSVM
% Segment image of character to compare in image
% image = segmented_image
% SVMModel_cell = treeSVM
% char = predictSVM(SVMModel_cell,image)

for k = 1:36
    char = predict(SVMModel_cell{k},image);    
    if strcmp(char,'-') == 0
        break
    end        
end

end