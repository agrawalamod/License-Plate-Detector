function segmentation(I)

plateName = 'IMG_0470.jpg';
I = imread(['./plate/' plateName]);
%Im = rgb2ycbcr(I);
%I = adaptivethreshold(I,30,0.05, 0);

% Remove keypad background
Icorrected = imtophat(I, strel('disk', 10));
level = graythresh(Icorrected);
BW1 = im2bw(Icorrected, level);
%I = adaptivethreshold(I,30,0.05, 0);
figure;
imshowpair(Icorrected, BW1, 'montage'), title('corrected');
% Perform morphological reconstruction and show binarized image.
marker = imerode(Icorrected, strel('line',20,0));
Iclean = imreconstruct(marker, Icorrected);

BW2 = im2bw(Iclean);

figure;
imshowpair(Iclean, BW2, 'montage'), title('clean');




Dx    = strel('square',1);      % Horizontal Extension
I = imdilate(I,Dx); 
Dr    = strel('square',1);             % Erosion
I    = imerode(I,Dr);

figure;imshow(I);
text = ocr(I)
