function houghTransform(edge_im1)

%im1 = imread('./image/IMG_0396.jpg');
%im1 = rgb2gray(im1);
edge_im1 = edge(edge_im1, 'canny', 0.4);
figure;
imshow(edge_im1);

[H,T,R] = hough(edge_im1);
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(edge_im1,T,R,P,'FillGap',8,'MinLength',8);

figure, imshow(edge_im1), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
h = getframe;
result = h.cdata;
imwrite(result,'hough_im1.jpg');