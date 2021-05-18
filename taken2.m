%%//Read in image
clear all;
close all;
Ireal = imread('Images/2000_real.jpeg'); % Real
Ifake = imread('Images/2000_fake.jpeg'); % Fake

%%//Pre-analysis
hsvImageReal = rgb2hsv(Ireal);
hsvImageFake = rgb2hsv(Ifake);
figure;
imshow([hsvImageReal(:,:,1) hsvImageReal(:,:,2) hsvImageReal(:,:,3)]);
title('Real');
figure;
imshow([hsvImageFake(:,:,1) hsvImageFake(:,:,2) hsvImageFake(:,:,3)]);
title('Fake');

%%//Initial segmentation
croppedImageReal = hsvImageReal(:,90:95,:);
croppedImageFake = hsvImageFake(:,93:98,:);
satThresh = 0.4;
valThresh = 0.3;
BWImageReal = (croppedImageReal(:,:,2) > satThresh & croppedImageReal(:,:,3) < valThresh);
figure;
subplot(1,2,1);
imshow(BWImageReal);
title('Real');
BWImageFake = (croppedImageFake(:,:,2) > satThresh & croppedImageFake(:,:,3) < valThresh);
subplot(1,2,2);
imshow(BWImageFake);
title('Fake');

%%//Post-process
se = strel('line', 6, 90);
BWImageCloseReal = imclose(BWImageReal, se);
BWImageCloseFake = imclose(BWImageFake, se);
figure;
subplot(1,2,1);
imshow(BWImageCloseReal);
title('Real');
subplot(1,2,2);
imshow(BWImageCloseFake);
title('Fake');

%%//Area open the image
figure;
areaopenReal = bwareaopen(BWImageCloseReal, 15);
subplot(1,2,1);
imshow(areaopenReal);
title('Real');
subplot(1,2,2);
areaopenFake = bwareaopen(BWImageCloseFake, 15);
imshow(areaopenFake);
title('Fake');

%%//Count how many objects there are
[~,countReal] = bwlabel(areaopenReal);
[~,countFake] = bwlabel(areaopenFake);
disp(['The total number of black lines for the real note is: ' num2str(countReal)]);
disp(['The total number of black lines for the fake note is: ' num2str(countFake)]);