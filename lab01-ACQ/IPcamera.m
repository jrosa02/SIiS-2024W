fh = figure;
ile_ramek = 100;
elapsedTime=zeros(1,ile_ramek);
for i = 1:ile_ramek
    tic
    IM = imread('http://149.156.124.49/axis-cgi/jpg/image.cgi');
    elapsedTime(1, i) = toc;
    imshow(IM);
    title(['ramka nr ' num2str(i)])
    drawnow
end
disp(['FPS = ' num2str(1/mean(elapsedTime))])

% FPS = 5.0646