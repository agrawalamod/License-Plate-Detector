function candidateRowImage = LocalizeRow(I)

%% Sobel Masking 
SM    = [-1 0 1;-2 0 2;-1 0 1];         % Sobel Vertical Mask
IS    = imfilter(I,SM,'replicate');     % Filter Image Using Sobel Mask
IS    = IS.^2;% Consider Just Value of Edges & Fray Weak Edges

% figure();imshow(IS)
%% Normalization
IS = (IS-min(IS(:)))/(max(IS(:))-min(IS(:))); % Normalization
% figure();imshow(IS)
%% Threshold (Otsu)
level = graythresh(IS);                 % Threshold Based on Otsu Method
IS    = im2bw(IS,level);
% figure();imshow(IS)
%% Histogram
S     = sum(IS,2);                      % Edge Horizontal Histogram
figure();plot(1:size(S,1),S)
view(90,90)
%% Plot
% figure()
% subplot(1,2,1);imshow(IS)
% subplot(1,2,2);plot(1:size(S,1),S)
% axis([1 size(IS,1) 0 max(S)]);view(90,90)
%% Plate Location
c_thresh = 0.20;% Threshold On Edge Histogram
d_thresh = 0.10;
T1 = 0.80;
max_value = max(S);
rows = size(S);
rows = rows(1);
candidate = [];
%{
for i = 2:rows-1
    if((S(i) >= c_thresh*max_value) && (S(i+1) >= d_thresh *max_value) && (S(i-1) >= d_thresh *max_value))
        candidate = [candidate;i;];
        
    end
end
%}
for i = 2:rows-1
    if((S(i) >= c_thresh*max_value) && (S(i+1) >= d_thresh *max_value))
        candidate = [candidate;i;];
        
    end
end

PR  = find(S > (T1*max(S))); % Candidate Plate Rows

min_value = min(candidate);
max_value = max(candidate);

height = max_value-min_value;

buffer =0.75;

if(min_value - uint8(buffer*height) >= 1)
    min_value = min_value - uint8(buffer*height);
else
    min_value = 1;
end

if(max_value + uint8(buffer*height) <= rows-1)
    max_value = max_value + uint8(buffer*height);
else
    max_value = rows-1;
end

new_candidate = [min_value:max_value;]
PR = new_candidate;


%% Masked Plate
Msk   = zeros(size(I));
Msk(PR,:) = 1; % Mask
MB    = Msk.*I;                        % Candidate Plate (Edge Image)
figure();imshow(MB)
test_MB = I(min_value:max_value,:);

candidateRowImage = test_MB;
%adaptivethreshold(test_MB,50,2);
figure();imshow(test_MB)
%houghTransform(test_MB);
