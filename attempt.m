colorImage = imread('./image/HPIM1280.JPG');
I = rgb2gray(colorImage);
%{
R = colorImage(:,:,1);
G = colorImage(:,:,2);
B = colorImage(:,:,3);
s = size(colorImage);
row = s(1);
col = s(2);
for i =1:col
    for j =1:row
        if(abs(R(j,i) - G(j,i)) <=50 && abs(R(j,i) - B(j,i)) <=50 && abs(G(j,i) - B(j,i)) <=50)
            %fprintf('True');
        else
            R(j,i) = 0;
            B(j,i) = 0;
            G(j,i) = 0;
            %fprintf('False');
            
            
        end
    end
end

    
original_mk2 = zeros(size(colorImage));
original_mk2(:,:,1) = R;
original_mk2(:,:,2) = G;
original_mk2(:,:,3) = B;
          
        
%}
%figure;
%imshow(original_mk2);

%I = medfilt2(I);

%figure;
%imshow(I);

%I = imgaussfilt(I);
%I = imsharpen(I, 'Radius', 2, 'Amount', 2);

%figure;
%imshow(I);

%im1 = imsharpen(im1,'Radius',2,'Amount',1.5,'Threshold', 0.1);

%edge_im1 = edge(I, 'canny', 0.4);
%imshow(edge_im1);

S = [-1 0 1;
    -2 0 2;
    -1 0 1];

A = imfilter(I,S','conv');
figure;
imshow(A);


