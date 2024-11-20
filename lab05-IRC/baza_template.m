%% (2) Tworzenie bazy wzorc�w
nrOfStrongest = 50; % ilosc najsilniejszych cech do wyboru

% <uzupe�nij>
% fileNames = { }; 
        
modelData=struct('objImage', [],...
                 'objValidPoints', [],...
                 'objFeatures', []);
             
for i=1:length(fileNames)
    % wczytanie pliku wzorca i konwersja do grayscale
    % (wskaz�wka - u�yj funkcji: imread, fullfile, rgb2gray)
    % <uzupe�nij>
    I_file = fileNames{i}; % Get current file name
    I = imread(I_file);  % Read the image
    
    % Convert to grayscale if image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end

    objImage = I;

    % detekcja cech SURF i wyb�r N najsilniejszych
    % (wskaz�wka - u�yj funkcji: 
    %     objPoints = detectSURFFeatures(...)
    %     objPoints = selectStrongest(...)
    % <uzupe�nij>

    % Detect SURF features
    points = detectSURFFeatures(I);
    
    % ekstrakcja wektora cech
    % (wskaz�wka - u�yj funkcji: [objFeatures, objValidPoints] = extractFeatures(...)    )
    % <uzupe�nij>
    [objFeatures, objValidPoints] = extractFeatures(I, points.selectStrongest(100)); % Plot the strongest 100 features
    
    % uzupelnianie zmiennej bazy danych
    modelData(i).objImage=objImage;
    modelData(i).objValidPoints=objValidPoints;
    modelData(i).objFeatures=objFeatures;
end
% zapis bazy do pliku MAT: save nazwapliku zmienna1 zmienna2 
% np. save ..... modelData nrOfStrongest
% <uzupe�nij>


save('modelData.mat', 'modelData', 'nrOfStrongest');
