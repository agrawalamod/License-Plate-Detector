% This code implemented license plate detection using morphological operators

% The steps are as follows:
% 1. Vertical edge detection
% 2. Histogram analysis
% 3. Vertical and Horizontal Dilation
% 4. Finding Regions in Common
% 5. Horizontal Dilation
% 6. Erosion
% 7. Post processing

%function k = Demo(imName)
%% clear command windows
%clc
%clear all
%close all
%% Read Image                              
imName = 'HPIM1018.jpg';
Im = imread(['./image/' imName]);
I     = im2double(rgb2gray(Im));        % rgb to gray
% figure();imshow(I)
%Im = adaptivethreshold(I,50,0.5);
%figure;
%imshow(Im);
%% Sobel Masking 
SM    = [-1 0 1;-2 0 2;-1 0 1];         % Sobel Vertical Mask
IS    = imfilter(I,SM,'replicate');     % Filter Image Using Sobel Mask
IS    = IS.^2;                          % Consider Just Value of Edges & Fray Weak Edges
%figure();imshow(IS)
%% Normalization
IS    = (IS-min(IS(:)))/(max(IS(:))-min(IS(:))); % Normalization
%figure();imshow(IS)
%% Threshold (Otsu)
level = graythresh(IS);                 % Threshold Based on Otsu Method
IS    = im2bw(IS,level);
%figure();imshow(IS)
%% Histogram
S = sum(IS,2);                      % Edge Horizontal Histogram
%figure();plot(1:size(S,1),S)
%view(90,90)
%% Plot
%figure()
%subplot(1,2,1);imshow(IS)
%subplot(1,2,2);plot(1:size(S,1),S)
%axis([1 size(IS,1) 0 max(S)]);view(90,90)
%% Plate Location
c_thresh = 0.80;% Threshold On Edge Histogram
d_thresh = 0.70;
T1 = 0.80;
max_value = max(S);
rows = size(S);
rows = rows(1);
candidate = [];
for i = 1:rows-1
    if((S(i) >= c_thresh*max_value) && (S(i+1) >= d_thresh *max_value))
        candidate = [candidate;i;];
        
    end
end

PR  = find(S > (T1*max(S))); % Candidate Plate Rows
%PR = new_candidate;
PR = candidate;

min_value = min(PR);
max_value = max(PR);
%{
if(min_value - 60 >= 1)
    min_value = min_value - 60;
else
    min_value = 1;
end

if(max_value + 60 <= rows-1)
    max_value = max_value + 60;
else
    max_value = rows-1;
end
%}
new_candidate = [min_value:max_value;];

%% Masked Plate
Msk   = zeros(size(I));
Msk2 = zeros(size(I));
Msk(PR,:) = 1; % Mask
Msk2(new_candidate,:) = 1;

MB = Msk.*IS;
%figure(333);imshow(MB);
cropIm = Msk2.*I;% Candidate Plate (Edge Image)
%figure();imshow(MB);
%figure(555);imshow(cropIm);

test_MB = cropIm(min_value:max_value,:);
%[colMin, colMax] = LocalizeCol(test_MB');
%MB = MB(:,colMin:colMax);

%figure(111);imshow(MB);
%% Morphology (Dilation - Vertical)
Dy    = strel('rectangle',[80,4]);      % Vertical Extension
MBy   = imdilate(MB,Dy);                % By Dilation
MBy   = imfill(MBy,'holes');            % Fill Holes
%figure();imshow(MBy)
%% Morphology (Dilation - Horizontal)
Dx    = strel('rectangle',[4,80]);      % Horizontal Extension
MBx   = imdilate(MB,Dx);                % By Dilation
MBx   = imfill(MBx,'holes');            % Fill Holes
%figure();imshow(MBx)
%% Joint Places
BIM   = MBx.*MBy;                       % Joint Places
%figure();imshow(BIM)
%% Morphology (Dilation - Horizontal)
Dy    = strel('rectangle',[4,30]);      % Horizontal Extension
MM    = imdilate(BIM,Dy);               % By Dilation
MM    = imfill(MM,'holes');             % Fill Holes
%figure();imshow(MM)
%% Erosion
Dr    = strel('line',50,0);             % Erosion
BL    = imerode(MM,Dr);
%figure();imshow(BL)
%% Find Biggest Binary Region (As a Plate Place)
[L,num] = bwlabel(BL);                  % Label (Binary Regions)               
Areas   = zeros(num,1);
for i = 1:num                           % Compute Area Of Every Region
[r,c,v]  = find(L == i);                % Find Indexes
Areas(i) = sum(v);                      % Compute Area    
end 
[La,Lb] = find(Areas==max(Areas));      % Biggest Binary Region Index
%% Post Processing
try
[a,b]   = find(L==La);  
% Find Biggest Binary Region (Plate)
[nRow,nCol] = size(I);
FM      = zeros(nRow,nCol);             % Smooth and Enlarge Plate Place
T       = 10;                           % Extend Plate Region By T Pixel
jr      = (min(a)-T :max(a)+T);
jc      = (min(b)-T :max(b)+T);
jr      = jr(jr >= 1 & jr <= nRow);
jc      = jc(jc >= 1 & jc <= nCol);
FM(jr,jc) = 1; 
PL      = FM.*I;
% Detected Plate
% figure();imshow(FM)
% figure();imshow(PL)
ht = abs(max(jr) - min(jr));
wd = abs(max(jc) - min(jc));
p1 = [min(jc) min(jr)];
p2 = [min(jc) min(jr)-ht];
p3 = [min(jc)+wd min(jr)-ht];
p4 = [min(jc)+wd min(jr)];

plate = Im;
plate = imcrop(plate,[min(jc),min(jr),max(jc)-min(jc),max(jr)-min(jr)]);
%figure;imshow(plate);
%% Plot
%figure('Visible', 'off');
figure;
imshow(Im); 
title('Detected Plate')
hold on
rectangle('Position',[min(jc),min(jr),max(jc)-min(jc),max(jr)-min(jr)],'LineWidth',4,'EdgeColor','r', 'Curvature',0.2)
hold off
h = getframe;
result = h.cdata;
imwrite(result,['./result/' imName]);
imwrite(plate, ['./plate/' imName]);

segmentation(plate);
catch
end

