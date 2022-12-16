clearvars; close all; clc;
load p1
load p2
load p3
load p4

test_plates = ['V6X717';'F3W678'; 'BID410';'ACU530';'F8N51N';'B6C329'; ...
               'ALH618';'B7B312';'BJB008';'AWE331';'BJN652';'AZW158'; ...
               'FOS029';'F3C175';'AFC511';'B6L329';'ADI452';'F7C080';'BAQ699'];

plate = [plate1;plate2;plate3;plate4];

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
%% Find Error
for j=1:size(plate,1)
    for k=1:length(plate)
        plt_cmp = plate{j,k};
        for i = 1:length(plate{j,k})
            comp(i) = strcmp(test_plates(k,i),plt_cmp(i));
        end
        error{j,k} = comp;
    end
end
%%

for j = 1:size(error,1)
    for k = 1:length(error)
        sum_e(j,k) = sum(error{j,k});
    end
end
Tsum_e = sum(sum_e,2);
pc = (Tsum_e./114)*100;
m = [1 2 3 4];

fprintf('error in model %2.2f\n',pc);



