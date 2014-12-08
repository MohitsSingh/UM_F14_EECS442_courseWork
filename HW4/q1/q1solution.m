
%% EECS 442 - HW 04 - Q1 Harris Corner Detection

%  Declaration
%  ------------
%  Date: 2014 / 11 / 06
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  ellipse(ra,rb,ang,x0,y0,C,Nb)

%  Instructions
%  ------------
%  Implement the Harris corner detector by computing the second moment 
%  matrix M at each pixel location. Compute the eigenvalues of M at every 
%  pixel locations. Compute the ellipses associated to such eigenvalues. 
%  Use the corner response R to assess whether a corner has been detected 
%  or not. Superimpose corners with R > T on the two images. 

%% Initialization
clear; close all; clc
%% ======================== Part 0: Load data =============================
img1 = imread('I1.png'); 
img2 = imread('I3.png');

img = img1;
w = 9;

%% ========== Part 1: compute M,R and ellipse parameter ===================

% applying sobel edge detector 

img_gray = img;
if length(size(img))>2
    img_gray = rgb2gray(img);
end 

% compute the image size
[height,width] = size(img_gray);   
% initialize corner position
result = zeros(height, width); 
% initialize R score
R = zeros(height, width);

%%applying sobel edge detector in the horizontal direction
fx = [-1 0 1;-1 0 1;-1 0 1];
Ix = filter2(fx,img_gray);
% applying sobel edge detector in the vertical direction
fy = [1 1 1;0 0 0;-1 -1 -1];
Iy = filter2(fy,img_gray); 

% compute terms for M
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;
clear Ix;
clear Iy;

% perform gaussian filtering for eliminating noises
h= fspecial('gaussian',[w w],2); 
Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

ellipsePerem = [];
Rmax = 0;
figure;
imshow(img);
hold on;
for i = 1:height
    for j = 1:width
        % compute M
        M = [
            Ix2(i,j), Ixy(i,j);
            Ixy(i,j) Iy2(i,j)
            ]; 
        % compute
        R(i,j) = det(M)-0.04*(trace(M))^2;
        if R(i,j) > Rmax
           Rmax = R(i,j);
        end;

    end;
end;
cnt = 0;
Rmax
% determine corner by comparing with threshold and all neighbor points
for i = 2:height-1
    for j = 2:width-1
        M = [
                 Ix2(i,j), Ixy(i,j);
                 Ixy(i,j) Iy2(i,j)
            ]; 
        % compute M's eigenvalue
        [vector,lambda] = eig(M);
        lambda = diag(lambda);
        % compute radius associate to the ellipse
        [lambda1,index] = max(lambda); 
        lambda2 = min(lambda); 
        a = lambda1^(-0.5);
        b = lambda2^(-0.5);
        vector = vector(:,index);
        angle = atan(vector(2)/vector(1));
        if mod(i,4) + mod(j,4) == 0
            ellipsePerem = [ellipsePerem;a b angle j i];
        end
        if R(i,j) > 0.1*Rmax &&...
            R(i,j) > R(i-1,j-1) ...
            && R(i,j) > R(i-1,j) ...
            && R(i,j) > R(i-1,j+1) ...
            && R(i,j) > R(i,j-1) ...
            && R(i,j) > R(i,j+1) ...
            && R(i,j) > R(i+1,j-1) ...
            && R(i,j) > R(i+1,j) ...
            && R(i,j) > R(i+1,j+1)
                
            result(i,j) = 1;
            cnt = cnt+1;
           % if (lambda1 - lambda2 <0.1)
            %end
        end;
    end;
end;
[posc, posr] = find(result == 1);
cnt ;
%% ========== Part 2: Plot ellipse and corner on image ====================

ellipse(ellipsePerem(:,1), ellipsePerem(:,2), ellipsePerem(:,3), ...
    ellipsePerem(:,4),ellipsePerem(:,5));
%plot(posr,posc,'r.');