clear all; close all; clc;

%% (1) Przygotowanie wzorca i obrazu testowego
wzorzecNr = 3;                  % Numer wzorca do badania
nrOfStrongest = 200;            % Liczba najsilniejszych cech

% Pobranie danych wzorca
load modeLData.mat
objImage        = modelData(wzorzecNr).objImage;
objValidPoints  = modelData(wzorzecNr).objValidPoints;
objFeatures     = modelData(wzorzecNr).objFeatures;

% Wczytanie obrazu testowego
RGB = imread('wszystkie_1.jpg');
sceneImage = rgb2gray(RGB); % Konwersja do skali szarości

% Detekcja i ekstrakcja cech charakterystycznych
scenePoints = detectSURFFeatures(sceneImage);
scenePoints = selectStrongest(scenePoints, nrOfStrongest);
[sceneFeatures, sceneValidPoints] = extractFeatures(sceneImage, scenePoints);

% Dopasowanie cech między wzorcem a obrazem testowym
featurePairs = matchFeatures(objFeatures, sceneFeatures, 'Unique', true);
matchedObjPoints = objValidPoints(featurePairs(:, 1), :);
matchedScenePoints = sceneValidPoints(featurePairs(:, 2), :);

% Wizualizacja dopasowanych cech
figure;
showMatchedFeatures(objImage, sceneImage, matchedObjPoints, matchedScenePoints, 'montage');
title('Dopasowanie przed usuwaniem outliers');

%% (2) Usunięcie outliers za pomocą algorytmu RANSAC
% Wyznaczenie transformacji geometrycznej (model Affine)
[tform, inlierObjPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedObjPoints, matchedScenePoints, 'affine', 'MaxDistance', 1.0);

% Wizualizacja dopasowania po usunięciu outliers
figure;
showMatchedFeatures(objImage, sceneImage, inlierObjPoints, inlierScenePoints, 'montage');
title('Dopasowanie po usunięciu outliers (RANSAC)');

%% (3) Wizualizacja prostokąta wzorca na obrazie testowym
% Definicja prostokąta wzorca
objPolygon = [1, 1; ...                               % Lewy górny róg
              size(objImage, 2), 1; ...               % Prawy górny róg
              size(objImage, 2), size(objImage, 1); ... % Prawy dolny róg
              1, size(objImage, 1); ...               % Lewy dolny róg
              1, 1];                                 % Powrót do lewego górnego rogu

% Wizualizacja prostokąta na obrazie wzorca
figure;
imshow(objImage);
hold on;
line(objPolygon(:, 1), objPolygon(:, 2), 'Color', 'r', 'LineWidth', 2);
title('Prostokąt na obrazie wzorca');

% Transformacja współrzędnych prostokąta za pomocą wyznaczonej transformacji
newObjPolygon = transformPointsForward(tform, objPolygon);

% Wizualizacja prostokąta na obrazie testowym
figure;
imshow(sceneImage);
hold on;
line(newObjPolygon(:, 1), newObjPolygon(:, 2), 'Color', 'y', 'LineWidth', 2);
title('Zlokalizowany obiekt na obrazie testowym');
