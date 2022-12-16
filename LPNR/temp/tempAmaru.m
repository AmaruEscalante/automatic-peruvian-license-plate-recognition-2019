close all
clearvars
clc

load Metrics_table

C = table2array(T(:,2));
pred = table2array(T(:,3));
k = 1; P(:,k) = cell2mat(pred(:,k));
k = 2; P(:,k) = cell2mat(pred(:,k));
k = 3; P(:,k) = cell2mat(pred(:,k));
k = 4; P(:,k) = cell2mat(pred(:,k));
k = 5; P(:,k) = cell2mat(pred(:,k));

Dif = bsxfun(@minus, C, P);
Nerrores = sum(Dif);
V = sum(Dif(:,1:3),2)>=2; % votación entre los modelos 1, 2 y 3
disp([Dif V]);
Nerrores2 = sum([Dif V]);
disp(Nerrores2);

% De abajo para arriba
% W: no tiene solución, pero si la salida es "Y" deberemos chequear con "W"
% también.
% O: considerar la posición de la letra: si es zona de número poner 0, sino
% O.
% N: si sale 5 en posición de letra, colocar N.
% I: si sale 1 en posición de letra, colocar I.
% D: no hay solución.
% B: si sale 8 o 6 en posición de letra, colocar B.
% 7: no hay solución.
% 2: solución global no hay, pero si sale I en posición de número colocar 2.
% 0: si sale O en posición de número, colocar 0.

% Pasos a seguir:
% 1. Coloca estas reglas en cada uno de los 3 primeros modelos por favor,
% ya no usaremos los modelos 4 ni 5. 
% 2. Una vez con esas arreglas implementadas en cada modelo, hace un 
% sistema de votación considerando como respuesta lo que diga la mayoría, 
% por ejemplo, si 2 modelos dicen que es V pero uno dice que es M, se
% considera la V.
% 3. Necesito que me envíes las fotos de las siguientes placas:
% % % La 2da placa que tiene W (todos fallaron ahí).
% % % La 3ra placa que tiene I (todos fallaron ahí).
% % % La 3ra placa que tiene D (todos fallaron ahí).
% % % La 8va placa que tiene 7 (todos fallar    on ahí).
% % % La 8va placa que tiene 2 (todos fallaron ahí).
%%
load p1;
load p2;
load p3;


test_plates = ['V6X717';'F3W678';'BID410';'ACU530';'F8N515';'B6C329'; ...
               'ALH618';'B7B312';'BJB008';'AWE331';'BJN652';'AZW158'; ...
               'F0S029';'F3C175';'AFC511';'B6L329';'ADI452';'F7C080';'BAQ699'];

% Pick only 6 characters
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
%% Sistema de votacion
for k = 1:length(plate)
    plt1 = plate{1,k};   
    plt2 = plate{2,k};             
    plt3 = plate{3,k};

    for l=1:length(plt1)
        mdl_compare = [plt1(l) plt2(l) plt3(l)];
        voted_str(l) = mode(mdl_compare);
    end
    voted_plate{k} = voted_str;
end
plate_voted = voted_plate;
plate = [plate(1,:);plate(2,:);plate(3,:);plate_voted];
%% Error
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
% Mdl 4 - Voted plates
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

