%% Finding boundaries
[B, L, n, A]= bwboundaries(BW);

figure;
imshow(BW); hold on;
for k=1:length(B)
   boundary = B{k};
   if(k > n)
     plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
   end
end
%%
for i = 1:10
    char1 = flattened_images(i,:); % an average flower
    charClass = predict(Mdl,char1);
    recognized_char = char(charClass);
    message = sprintf('Recognized character is : %s', recognized_char);
    disp(message)
end
