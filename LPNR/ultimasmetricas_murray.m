clearvars; clc; close all;
plate = ["81841O","81O410","81B418";
         "81041O" ,"81O41O" "81B418";
         "Y81041O" "Y81D41O" "781B418"];

%% Select only the first 6 characters 
for j = 1:size(plate,1)
    for k = 1:length(plate)
        plt = plate{j,k};   
        if length(plate{j,k})>6
            plate{j,k} = plt(1:6);
        end
    end
end

%% RULES
for j = 1:size(plate,1)
    for k = 1:length(plate) 
        plt = plate{j,k};
        p_end = plt(4:end);
        p_beg = plt(1:3);
        % Last 3 digits are NUMBERS
        for l = 1:3
           if strcmp(p_end(l),'O') == 1
            p_end(l) = '0';  
           elseif strcmp(p_end(l),'I')== 1
            p_end(l) = '2';  
        %   elseif strcmp(p_end(l),'J') == 1
        %    p_end(l) = '1';  
        %   elseif strcmp(p_end(l),'I') == 1
        %    p_end(l) = '2';  
        %   elseif strcmp(p_end(l),'Q') == 1
        %    p_end(l) = '0';  
           end
        end
        % First 3 Digits follow A1C-234 order
         for l = 1:2:3
           if strcmp(p_beg(l),'0') == 1
            p_beg(l) = 'O';  
           elseif strcmp(p_beg(l),'8')||strcmp(p_beg(l),'6') == 1
            p_beg(l) = 'B';  
           elseif strcmp(p_beg(l),'1') == 1
            p_beg(l) = 'I';
           elseif strcmp(p_beg(l),'5') == 1
            p_beg(l) = 'N';   
           elseif strcmp(p_beg(l),'Y') == 1
            p_beg(l) = 'W';              
           end
         end        
        plt(1:3) = p_beg;
        plt(4:end) = p_end;
        plate{j,k} = plt;  
    end
end