%% (1-2) Szablon do przeprowadzania testów
close all; clc;

% Parametry testu
baseFileName = 'obraz_';        % Bazowa nazwa plików testowych
fileExtension = '.jpg';         % Rozszerzenie plików testowych
fileNr = 1:17;                  % Numery plików testowych
wzorzecNr = 3;                  % Numer wzorca do badania
visON = 1;                      % 1 - włączenie wizualizacji, 0 - wyłączenie

% Pobranie danych wzorca
load modeLData.mat
objImage = modelData(wzorzecNr).objImage;
objValidPoints = modelData(wzorzecNr).objValidPoints;
objFeatures = modelData(wzorzecNr).objFeatures;

% Preallokacja wektora rezultatów
metric1 = zeros(length(fileNr), 1);

% Pętla – wczytywanie kolejnych obrazów i wyznaczenie dopasowania
for i = 1:length(fileNr)
    % Generowanie nazwy pliku
    nazwa1 = fullfile(pwd, [baseFileName, num2str(fileNr(i)), fileExtension]);
    disp(['Processing file: ', nazwa1]);
    
    % Wczytanie obrazu testowego i konwersja do skali szarości
    RGB = imread(nazwa1);
    sceneImage = rgb2gray(RGB);
    
    % Detekcja cech, wybór N najsilniejszych, ekstrakcja cech
    scenePoints = detectSURFFeatures(sceneImage);
    scenePoints = scenePoints.selectStrongest(100); % Wybór 100 najsilniejszych punktów
    [sceneFeatures, sceneValidPoints] = extractFeatures(sceneImage, scenePoints);
    
    % Dopasowanie cech między wzorcem a aktualnym obrazem
    featurePairs = matchFeatures(objFeatures, sceneFeatures, 'Unique', true);
    matchedObjPoints = objValidPoints(featurePairs(:, 1), :);
    matchedScenePoints = sceneValidPoints(featurePairs(:, 2), :);
    
    % Wizualizacja dopasowania cech
    if visON == 1
        figure;
        showMatchedFeatures(objImage, sceneImage, matchedObjPoints, matchedScenePoints, 'montage');
        title(['Matched Features for Image ', num2str(fileNr(i))]);
    end
    
    % Wyznaczenie miary dopasowania i zapisanie do zmiennej
    metric1(i) = length(matchedObjPoints) / length(objValidPoints);
end

% Wyświetlenie miary dopasowania
figure;
plot(fileNr, metric1, '-o');
title('Miara dopasowania dla obrazów testowych');
xlabel('Numer pliku');
ylabel('Miara dopasowania');
grid on;

%% (3) Algorytm klasyfikacji obrazów testowych
close all;

% Ręczna adnotacja poprawnej klasyfikacji dla bazy
groundTruthTab = {
    [1, 2, 3, 4],  % Obrazy testowe zawierające wzorzec 1
    [5, 6, 7, 8, 9],  % Obrazy testowe zawierające wzorzec 2
    [10, 11, 12, 13],  % Obrazy testowe zawierające wzorzec 3
    [14, 15, 16, 17, 18] % Obrazy testowe zawierające wzorzec 4
};

% Przyjęty procentowy próg rozpoznania
threshold1 = 0.1; % Dobierz na podstawie wyników testów

% Znalezienie obrazów dla których miara dopasowania jest > progu
groundTruth = groundTruthTab{wzorzecNr};
detected = find(metric1 > threshold1);

% Wizualizacja miary dopasowania i wyników klasyfikacji
figure;
hold on;
plot(fileNr, metric1, '-bo', 'DisplayName', 'Miara dopasowania'); % niebieskie linia ciągła, marker kropka
plot(groundTruth, metric1(groundTruth), 'rx', 'MarkerSize', 10, 'DisplayName', 'Poprawna klasyfikacja'); % czerwone krzyżyki
plot(detected, metric1(detected), 'go', 'MarkerSize', 10, 'DisplayName', 'Wynik klasyfikacji'); % zielone kółka
yline(threshold1, 'k--', 'DisplayName', 'Próg rozpoznania'); % czarna przerywana linia
hold off;

% Legenda i opisy osi
title('Wyniki klasyfikacji obrazów testowych');
xlabel('Numer pliku');
ylabel('Miara dopasowania');
legend('show');
grid on;

% Wyznaczenie błędów I i II rodzaju
falsePositives = setdiff(detected, groundTruth); % Wykryte, ale nieprawidłowe
falseNegatives = setdiff(groundTruth, detected); % Nie wykryte, ale poprawne
truePositives = intersect(detected, groundTruth);

disp('True Positives:');
disp(truePositives);
disp('False Positives:');
disp(falsePositives);
disp('False Negatives:');
disp(falseNegatives);

% Obliczenie poziomu istotności i mocy testu
precision = length(truePositives) / (length(truePositives) + length(falsePositives));
recall = length(truePositives) / (length(truePositives) + length(falseNegatives));
f1Score = 2 * (precision * recall) / (precision + recall);

disp(['Precision: ', num2str(precision)]);
disp(['Recall: ', num2str(recall)]);
disp(['F1 Score: ', num2str(f1Score)]);
