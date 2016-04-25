
%% clear command windows
clc
clear all
close all
%% Read Image                              
imName = 'IMG_0485.jpg';
Im = imread(['./image/' imName]);
I     = im2double(rgb2gray(Im));        % rgb to gray
% figure();imshow(I)
%Im = adaptivethreshold(I,50,0.5);
figure;
imshow(Im);

CandidateRowImage = LocalizeRow(I);
CandidateColumnImage = LocalizeCol(CandidateRowImage');

segmentation(CandidateColumnImage);
