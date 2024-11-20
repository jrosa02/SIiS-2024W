clear all;close all;clc

%% (1) 
wzorzecNr = 1;                  % numer wzorca do badania
nrOfStrongest = 100;            % max. ilosc najsilniejszych cech do wyboru

% pobranie danych wzorca
load bazaWzorcow
objImage        = modelData(wzorzecNr).objImage;
objValidPoints  = modelData(wzorzecNr).objValidPoints;
objFeatures     = modelData(wzorzecNr).objFeatures;

% wczytanie obarazu testowego
RGB = imread('wszystkie_1.jpg');

% detekcja i ekstrakcja cech charakterystycznych 
sceneImage = rgb2gray(RGB); 

% detekcja cech, wybór N najsilniejszych, ekstrakcja wektorów cech
scenePoints = detectSURFFeatures(sceneImage);
scenePoints = selectStrongest(scenePoints, nrOfStrongest);
[sceneFeatures, sceneValidPoints] = extractFeatures(sceneImage, scenePoints);
    
% dopasowanie cech między wzorcem a aktualnym obrazem
featurePairs        = matchFeatures(objFeatures, sceneFeatures,'unique',true);
matchedObjPoints    = objValidPoints(featurePairs(:, 1), :);
matchedScenePoints  = sceneValidPoints(featurePairs(:, 2), :);
    
% wizualizacja dopasowania cech
figure;
showMatchedFeatures(objImage, sceneImage, matchedObjPoints, ...        
    matchedScenePoints, 'montage');
title('dopasowanie przed usuwanie outliers')

%% (2)
% Usunięcie "outliers" poprzez estymację transformacji geometrycznej i RANSAC
% <uzupelnij>
% [tform, inlierObjPoints, inlierScenePoints] = ...

figure;
showMatchedFeatures(objImage, sceneImage, inlierObjPoints, ...
    inlierScenePoints, 'montage');
title('dopasowanie po RANSAC');

%% (3) Wizualizacja (użycie parametrów transformacji)
% objPolygon = [1, 1;...                            % top-left
%        size(objImage, 2), 1;...                   % top-right
%        <uzupelnij>;...                            % bottom-right
%        <uzupelnij>;...                            % bottom-left
%        <uzupelnij>];                              % top-left again to close the polygon
    
% sprawdzenie prostokąta
figure;
imshow(objImage);
hold on
line(objPolygon(:, 1), objPolygon(:, 2), 'Color', 'r');

% transformacja współrzędnych i wizualizacja rezutlatu
% <uzupelnij>
%  newObjPolygon = transformPointsForward(...);    
figure;
imshow(sceneImage);
hold on;
line(newObjPolygon(:, 1), newObjPolygon(:, 2), 'Color', 'y');
title('Zlokalizowany obiekt');

