colorImage = imread('1.jpg');
I = rgb2gray(colorImage);


figure;
imshow(I);

%I = medfilt2(I);

figure;
imshow(I);

%I = imgaussfilt(I);
%I = imsharpen(I, 'Radius', 2, 'Amount', 2);

figure;
imshow(I);

%im1 = imsharpen(im1,'Radius',2,'Amount',1.5,'Threshold', 0.1);
edge_im1 = edge(I, 'canny', 0.4);
imshow(edge_im1);

figure, imcontour(edge_im1);

