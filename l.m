im = imread('2.jpg');
im = rgb2gray(im);

im = adaptivethreshold(im,20,0.2);
imshow(im);