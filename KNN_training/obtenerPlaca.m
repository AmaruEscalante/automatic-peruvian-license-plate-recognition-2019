function Y = obtenerPlaca( I )

umbral = 0.3;
I = SeccionPlaca(I, umbral);
original = I;

figure();
imagesc(I); colormap('gray'); axis('image');
title('Primera Segmentacion');

%% ----------------- Operaciones Morfológicas ---------------
SE = [0 0 1 0 0
0 1 1 1 0
1 1 1 1 1
0 1 1 1 0
0 0 1 0 0];

% erosion
erosion = imerode(I, SE);

% dilatacion
apertura = imdilate(erosion, SE);

% cierre
I = apertura - erosion;

figure();
imagesc(I); colormap('gray'); axis('image');
title('Transformaciones');

%% ---------------- Detección de borden canny ---------------
BW = edge(I, 'canny', umbral);
figure;
imagesc(BW); title('Canny2');

% Suavizado de la imagen para reducir el número de componentes conectados
mask = [0 0 0 0 0
0 1 1 1 0
0 1 1 1 0
0 1 1 1 0
0 0 0 0 0];

B = conv2(single(BW), single(mask));

figure();
imagesc(B); colormap('gray'); axis('image');
title('Mejora: Bordes');


%% ------------------ Calculo de regiones -------------------
L = bwlabel(B, 8);				% Remarca bordes

d2 = imfill(L, 'holes');		% Llena areas con pixeles en blanco

[etiquetas, N] = bwlabel(d2);	% Remarca bordes

mapa = [0 0 0; jet(N)];			% Consigue indices
I = ind2rgb(etiquetas + 1, mapa);	% Cambia indices a imagen

figure();
imagesc(I); colormap('gray'); axis('image');
title('Mejora: Regiones');

%% ------------------- Identificación de la región de la matricula -------------------

stats = regionprops(etiquetas, 'all');
areaMaxima = sort([stats.Area], 'descend');
indiceLogo = find([stats.Area] == areaMaxima(1) ); % Coloca en orden de mayor a menor las áreas de la imagen

for i = 1:size(indiceLogo, 2)
	rectangle('Position', stats(indiceLogo(i)).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 3);
	E = stats(indiceLogo(i)).BoundingBox;
end


%% ------------------- Mostrar resultado -------------------

X = E.*[1 0 0 0]; X = max(X); % Determina eje X esquina superior Izq. Placa
Y = E.*[0 1 0 0]; Y = max(Y); % Determina eje Y esquina superior Der. Placa
W = E.*[0 0 1 0]; W = max(W); % Determina Ancho Placa
H = E.*[0 0 0 1]; H = max(H); % Determina Altura placa
Corte = [X Y W H]; % Determina coordenadas de corte

Y = imcrop(original,Corte);

end