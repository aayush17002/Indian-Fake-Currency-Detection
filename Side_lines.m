%% read Images
clc;
clear all;
close all;
Ireal = imread('Images/50_real.jpeg'); % Real
Ifake = imread('Images/50_fake.jpeg'); % Fake

%% Pre-analysis
hsvImageReal = rgb2hsv(Ireal);
hsvImageFake = rgb2hsv(Ifake);
figure;
imshow([hsvImageReal(:,:,1) hsvImageReal(:,:,2) hsvImageReal(:,:,3)]);
title('Real');
figure;
imshow([hsvImageFake(:,:,1) hsvImageFake(:,:,2) hsvImageFake(:,:,3)]);
title('Fake');

%% Segmentation
croppedImageReal = hsvImageReal(300:800,1:140,:);
croppedImageFake = hsvImageFake(200:700,1:120,:);
satThresh = 0.02;
valThresh = 0.95;
BWImageReal = (croppedImageReal(:,:,2) > satThresh & croppedImageReal(:,:,3) < valThresh);
BWImageFake = (croppedImageFake(:,:,2) > satThresh & croppedImageFake(:,:,3) < valThresh);

%% Post-process
se = strel('line', 3, 90);
BWImageCloseReal = imclose(BWImageReal, se);
BWImageCloseFake = imclose(BWImageFake, se);

%% Area open the image
figure;
areaopenReal = bwareaopen(BWImageCloseReal, 15);
subplot(1,2,1);
imshow(areaopenReal);
title('Real');
subplot(1,2,2);
areaopenFake = bwareaopen(BWImageCloseFake, 15);
imshow(areaopenFake);
title('Fake');

%% Count how many objects there are
[~,countReal] = bwlabel(areaopenReal);
[~,countFake] = bwlabel(areaopenFake);
disp(['The total number of black lines for the real note is: ' num2str(countReal)]);
disp(['The total number of black lines for the fake note is: ' num2str(countFake)]);
