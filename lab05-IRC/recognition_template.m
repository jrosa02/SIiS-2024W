%% (1-2) Szablon do przeprowadzania test�w (wczytanie obrazow w trybie wsadowym, generacja nazw plikow...)
close all;clc
% parametry testu 
baseFileName = 'obraz_';        % bazowa nazwa plik�w testowych
fileExtension = '.jpg';         % rozszerzenie plik�w testowych
fileNr = 1:17;                  % numery plik�w testowych

wzorzecNr = 1;                  % numer wzorca do badania
visON     = 1;                  % 1- w��czenie wizualizacji, 0-wy��czenie

% pobranie danych wzorca
load bazaWzorcow
objImage = modelData(wzorzecNr).objImage;
%<uzupe�nij>  objValidPoints = ...
%<uzupe�nij>  objFeatures = ...
% (wskaz�wka: zwr�� uwag� na fakt, �e objFeatures jest tablic�, a
% objValidPoints - struktur�)

% p�tla � wczytywanie kolejnych obraz�w i wyznaczenie dopasowania
metric1=zeros(length(fileNr),1); % wektor rezultat�w (preallokacja)
for i=1:length(fileNr)     
    % nazwa wczytywanego pliku
    % <uzupelnij>
    % nazwa1 = fullfile(<path>,<filename>)
    %          <filename> sk�ada si� z: baseFileName, num2str(fileNr(i)), fileExtension

    disp(nazwa1);
    RGB=imread(nazwa1);
    sceneImage = rgb2gray(RGB); 
        
    % detekcja cech, wyb�r N najsilniejszych, ekstrakcja wektor�w cech
    % <uzupe�nij>
    %      scenePoints = detectSURFFeatures(...);
    %      scenePoints = selectStrongest(...);
    %      [sceneFeatures, sceneValidPoints] = extractFeatures(...);
   

    % dopasowanie cech mi�dzy wzorcem a aktualnym obrazem
    featurePairs = matchFeatures(objFeatures, sceneFeatures,'unique',true);
    matchedObjPoints = objValidPoints(featurePairs(:, 1), :);
    matchedScenePoints = sceneValidPoints(featurePairs(:, 2), :);
    
    % wizualizacja dopasowania cech
    if visON==1
        figure;
        showMatchedFeatures(objImage, sceneImage, matchedObjPoints, ...        
            matchedScenePoints, 'montage');
    end
    
    % wyznaczenie miary dopasowania I zapami�tanie w zmiennej
    metric1(i) = length(matchedObjPoints) / length(objValidPoints);
end
% Wy�wietl na osobnym wykresie miar� dopasowania "metric1"
% <uzupe�nij>

%% (3) Uzupe�nij kod (osobna sekcja) o prosty algorytm klasyfikacji obraz�w testowych
close all;
groundTruthTab={};
% poprawna klasyfikacja (reczna adnotacja dla bazy)
% <uzupe�nij>:  groundTruthTab{1} = ...

% przyj�ty procentowy pr�g rozpoznania
% <uzupe�nij>: threshold1 = ...           

% dla wybranego wzorca, znalezienie obraz�w dla kt�rych miara dopasowania
% jest > przyj�tego progu
groundTruth = groundTruthTab{wzorzecNr};
% <uzupe�nij>: detected = ...

% wizualizacja rezultat�w i poprawnej klasyfikacji
% <uzupe�nij>

% wyznaczenie bledow I i II rodzaju oraz poziomu istotno�ci i mocy testu
% <uzupe�nij>


