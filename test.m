% input - give the image file name as input. eg :- car3.jpg
clc;
clear all;
% k=input('Enter the file name','s'); % input image; color image
im=imread('Images/2000_fake.jpeg');
figure; imshow(im);
im1=rgb2gray(im);
im1=medfilt2(im1,[3 3]); %Median filtering the image to remove noise%
BW = edge(im1,'sobel'); %finding edges
figure; imshow(im1);
[imx,imy]=size(BW);
msk1=[0 0 0 0 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 0 0 0 0;];

B=conv2(double(BW),double(msk1)); %Smoothing  image to reduce the number of connected components
msk2=[1 1 1 1 1;
     1 0 0 0 1;
     1 0 0 0 1;
     1 0 0 0 1;
     1 1 1 1 1;];
B=conv2(double(B),double(msk2));
L = bwlabel(B,8);% Calculating connected components
values=unique(L).';
mx=max(max(L))
% There will be mx connected components.Here U can give a value between 1 and mx for L or in a loop you can extract all connected components
% If you are using the attached car image, by giving 17,18,19,22,27,28 to L you can extract the number plate completely.
figure,imshow(B);
for j=1:mx
    [r,c] = find(L==j);  
    rc = [r c];
    [sx sy]=size(rc);
    n = zeros(imx,imy);
    for i=1:sx
        x1=rc(i,1);
        y1=rc(i,2);
        n(x1,y1)=255;
    end % Storing the extracted image in an array
%     figure,imshow(n,[]); title(j)
    name=sprintf('segim%d.png',j);
    imwrite(n,name,'PNG');
end
