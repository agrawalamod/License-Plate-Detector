function [plateNo, result] = segmentation(I)

%plateName = 'IMG_0473.jpg';
%plateName = I;
%I = imread(['./plate/' plateName]);
%Im = imread(['./plate/' plateName]);
I = rgb2gray(I);
angle = horizon(I, 0.1, 'hough');
%I = imrotate(I,-angle);
%figure, imshowpair(I, Img, 'montage'), title('rotated image');


I = 255 - I;
%figure, imshow(I);


level = graythresh(I);
I = im2bw(I, level);
I = adaptivethreshold(I,50,0.01, 0);
%figure, imshow(I);

marker = imerode(I, strel('line',2,90));
I = imreconstruct(marker, I);


%figure, imshowpair(I, I, 'montage'), title('artificats removed');

%I = imrotate(I,angle);
I = bwdist(I) <= 0.9;
CC = bwconncomp(I);
label = bwlabel(I, 4);
st = regionprops(label, 'boundingbox');
[height, width] = size(I);

figure('Visible', 'off') , hold on
imshow(I);
plateNo = [];
 for k = 1 : length(st)
  thisBB = st(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',1 )
   r = thisBB(3)/height;
   
   pA = (thisBB(3)*thisBB(4))/(height*width) ;
   
   if ((thisBB(4)/height) > 0.1 && (thisBB(4)/height) < 1.5 && thisBB(3)< 20) % enforce a limit to discard non-letters
    %text=ocr(I,st(k).BoundingBox, 'TextLayout', 'Block', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' )
    rectangle('Position',st(k).BoundingBox+[-1 -1 2 2 ],'Edgecolor','y')

    plate = imcrop(I,[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]);
    plate = imrotate(plate,-angle);
    %plate=imresize(plate,[42 24]);
   
    Dx    = strel('square',1);      % Horizontal Extension
    plate = imdilate(plate,Dx);
    Dr    = strel('square',1);             % Erosion
    plate = imerode(plate,Dr);
    %imshow(plate);
    text=ocr(plate, 'TextLayout', 'Block', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789OI' );
    t = text.Text;
    strcat('|',t, '|');
    
    if(length(t)<4)
       
    
    
    %plateNo = strcat(plateNo, text.Text);
    
    if(thisBB(1) > (width/2)-5)
        
        %text=ocr(plate, 'TextLayout', 'Block', 'CharacterSet', '0123456789OI' );
        
        if(strncmp(text.Text,{'I'}, 1))
            plateNo = strcat(plateNo, '1');
        elseif (strncmp(text.Text,{'U'}, 1))
            plateNo = strcat(plateNo, '0'); 
        elseif (strncmp(text.Text, {'S'}, 1))
            plateNo = strcat(plateNo, '5');
        elseif (strncmp(text.Text, 'Z', 1))
            plateNo = strcat(plateNo, '2');
        elseif (strncmp(text.Text, 'E', 1))
            plateNo = strcat(plateNo, '6');
        elseif (strncmp(text.Text, 'B', 1))
            plateNo = strcat(plateNo, '6');
        elseif (strncmp(text.Text, 'D', 1))
            plateNo = strcat(plateNo, '0');
        elseif (strncmp(text.Text, 'L', 1))
            plateNo = strcat(plateNo, '2');
        else
            plateNo = strcat(plateNo, t);
        end
        
    
    else 
       %text=ocr(plate, 'TextLayout', 'Block', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' );
       if(strncmp(text.Text,{'1'}, 1))
            plateNo = strcat(plateNo, 'I');
            
       else
           plateNo = strcat(plateNo, t);
       end
        
    end
    
    %letter = readLetter(plate)
     
    %pause
    end
   end
     
   
end
hold off;
h= getframe;
result = h.cdata;
plateNo
%{
f =fopen('ocr2.txt','a');
plateNo
fprintf(f,'%s %s \n',plateName, plateNo);
imwrite(h.cdata,['./result2/' plateName]);
%}












%{
%for shadow on plate
% Remove some columns from the beginning and end
I = I(:,15:end-15);
%figure, imshow(I);

% Cast to double and do log.  We add with 1 to avoid log(0) error.
I = im2double(I);
I = log(1 + I);
%figure, imshow(I);

% Create Gaussian mask in frequency domain
% We must specify our mask to be twice the size of the image to avoid
% aliasing.
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;
sigma = 4;
[X, Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);
centerY = ceil(M/2);
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;

% Low pass and high pass filters
Hlow = exp(-gaussianNumerator./(2*sigma.^2));
Hhigh = 1 - Hlow;


% Move origin of filters so that it's at the top left corner to match with
% input image
Hlow = ifftshift(Hlow);
Hhigh = ifftshift(Hhigh);

% Filter the image, and crop
If = fft2(I, M, N);
Ioutlow = real(ifft2(Hlow .* If));
Iouthigh = real(ifft2(Hhigh .* If));

% Set scaling factors then add
gamma1 = 0.3;
gamma2 = 1.5;
Iout = gamma1*Ioutlow(1:size(I,1),1:size(I,2)) + ...
       gamma2*Iouthigh(1:size(I,1),1:size(I,2));

% Anti-log then rescale to [0,1]
Ihmf = exp(Iout) - 1;
Ihmf = (Ihmf - min(Ihmf(:))) / (max(Ihmf(:)) - min(Ihmf(:)));
%figure, imshow(Ihmf);

% Threshold the image - Anything below intensity 65 gets set to white
Ithresh = Ihmf < 65 /255;
figure, imshow(Ithresh);

% Remove border pixels
Iclear = imclearborder(Ithresh, 4);


% Eliminate regions that have areas below 160 pixels
Iopen = bwareaopen(Iclear, 40);
figure, imshow(Iopen);

text = ocr(Iopen) 
%}

%{ 
working
Dx    = strel('square',1);      % Horizontal Extension
I = imdilate(I,Dx); 
Dr    = strel('square',1);             % Erosion
I    = imerode(I,Dr);

figure;imshow(I);
text = ocr(I) 
%}
