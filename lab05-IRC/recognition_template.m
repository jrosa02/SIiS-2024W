%% (1-2) Szablon do przeprowadzania testów (wczytanie obrazow w trybie wsadowym, generacja nazw plikow...)
close all;clc
% parametry testu 
baseFileName = 'obraz_';        % bazowa nazwa plików testowych
fileExtension = '.jpg';         % rozszerzenie plików testowych
fileNr = 1:17;                  % numery plików testowych

wzorzecNr = 1;                  % numer wzorca do badania
visON     = 1;                  % 1- w³¹czenie wizualizacji, 0-wy³¹czenie

% pobranie danych wzorca
load bazaWzorcow
objImage = modelData(wzorzecNr).objImage;
%<uzupe³nij>  objValidPoints = ...
%<uzupe³nij>  objFeatures = ...
% (wskazówka: zwróæ uwagê na fakt, ¿e objFeatures jest tablic¹, a
% objValidPoints - struktur¹)

% pêtla – wczytywanie kolejnych obrazów i wyznaczenie dopasowania
metric1=zeros(length(fileNr),1); % wektor rezultatów (preallokacja)
for i=1:length(fileNr)     
    % nazwa wczytywanego pliku
    % <uzupelnij>
    % nazwa1 = fullfile(<path>,<filename>)
    %          <filename> sk³ada siê z: baseFileName, num2str(fileNr(i)), fileExtension

    disp(nazwa1);
    RGB=imread(nazwa1);
    sceneImage = rgb2gray(RGB); 
        
    % detekcja cech, wybór N najsilniejszych, ekstrakcja wektorów cech
    % <uzupe³nij>
    %      scenePoints = detectSURFFeatures(...);
    %      scenePoints = selectStrongest(...);
    %      [sceneFeatures, sceneValidPoints] = extractFeatures(...);
   

    % dopasowanie cech miêdzy wzorcem a aktualnym obrazem
    featurePairs = matchFeatures(objFeatures, sceneFeatures,'unique',true);
    matchedObjPoints = objValidPoints(featurePairs(:, 1), :);
    matchedScenePoints = sceneValidPoints(featurePairs(:, 2), :);
    
    % wizualizacja dopasowania cech
    if visON==1
        figure;
        showMatchedFeatures(objImage, sceneImage, matchedObjPoints, ...        
            matchedScenePoints, 'montage');
    end
    
    % wyznaczenie miary dopasowania I zapamiêtanie w zmiennej
    metric1(i) = length(matchedObjPoints) / length(objValidPoints);
end
% Wyœwietl na osobnym wykresie miarê dopasowania "metric1"
% <uzupe³nij>

%% (3) Uzupe³nij kod (osobna sekcja) o prosty algorytm klasyfikacji obrazów testowych
close all;
groundTruthTab={};
% poprawna klasyfikacja (reczna adnotacja dla bazy)
% <uzupe³nij>:  groundTruthTab{1} = ...

% przyjêty procentowy próg rozpoznania
% <uzupe³nij>: threshold1 = ...           

% dla wybranego wzorca, znalezienie obrazów dla których miara dopasowania
% jest > przyjêtego progu
groundTruth = groundTruthTab{wzorzecNr};
% <uzupe³nij>: detected = ...

% wizualizacja rezultatów i poprawnej klasyfikacji
% <uzupe³nij>

% wyznaczenie bledow I i II rodzaju oraz poziomu istotnoœci i mocy testu
% <uzupe³nij>


