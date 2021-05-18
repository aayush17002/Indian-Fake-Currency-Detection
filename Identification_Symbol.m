%% Read in image
clc;
clear all;
close all;
Ireal = imread('Images/2000_real.jpeg'); % Real
Ifake = imread('Images/2000_fake.jpeg'); % Fake
[x,y,z] = size(Ireal);

%% Pre-analysis
hsvImageReal = rgb2hsv(Ireal);
hsvImageFake = rgb2hsv(Ifake);
figure;
imshow([hsvImageReal(:,:,1) hsvImageReal(:,:,2) hsvImageReal(:,:,3)]);
title('Real');
figure;
imshow([hsvImageFake(:,:,1) hsvImageFake(:,:,2) hsvImageFake(:,:,3)]);
title('Fake');

%% Initial segmentation
croppedImageReal = hsvImageReal(:,y-400:y-100,:);
croppedImageFake = hsvImageFake(:,y-400:y-100,:);
satThresh = 0.1;
valThresh = 0.9;
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