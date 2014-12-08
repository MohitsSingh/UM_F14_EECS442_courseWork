%% EECS 442 - HW 04 - Q2 Blob Detection

%  Declaration
%  ------------
%  Date: 2014 / 11 / 06
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  show_all_circles(I, cx, cy, rad, color, ln_wid)

%  Instructions
%  ------------
%  Implement a blob detector based on the Laplacian operator and 
%  characteristic scale concept introduced by Lindeberg. Compute the radius
%  of each blob (in pixels) and report the histogram (dis- tribution)
%  of radii computed for the whole image.

%% Initialization
clc
clear
close all
%% =============== Part 0: Parameter selection ============================
t = 1:0.1:3;
sigma_scale = exp(t);
sigma_scale = sigma_scale';
%levels = 10;
levels = length(sigma_scale);
%% ======================== Part 1: Load data =============================
img = imread('3.bmp');
img = rgb2gray(img);
img = img;

dimg = double(img);

% Scale space creation:
[height width] = size(img);
scale_space = zeros(height,width,levels);

%% ================ Part 2: Perform detection =============================

for i=1:levels
    
% Filter creation:
filter_size = 2*ceil(3*sigma_scale(i))+1;
kernel = fspecial('log', filter_size, sigma_scale(i));

nLoG = sigma_scale(i)^2 * kernel;
imFilt = imfilter(dimg, nLoG, 'same', 'replicate');
imFilt = imFilt .^ 2;
scale_space(:,:,i) = imFilt;
end

% Perform non-maximum suppression in the 3D scale space
% used vl_localmax in vlfeat for detection
thres = 0.3 * max(max(max(scale_space)));
thres = 1500;
max(max(max(scale_space)))

scale_space_filtered = zeros(height,width,levels);

for i=1:levels
    scale_space_filtered(:,:,i) = ordfilt2(scale_space(:,:,i),9,ones(3));
end
%non maximum supression between scales

for i = 1:levels
    scale_space_filtered(:,:,i) = ...
        max(scale_space_filtered(:,:,max(i-1,1):min(i+1,levels)),[],3);
end
scale_space_filtered...
    = scale_space_filtered .* (scale_space_filtered == scale_space);


r = [];
c = [];
rad = [];
for i=1:levels
    [rows,cols] = find(scale_space_filtered(:,:,i)>=thres);
    num = length(rows);
    radii = sigma_scale(i)*sqrt(2);
    radii = repmat(radii,num,1);
    r = [r;rows];
    c = [c;cols];
    rad = [rad;radii];
end
show_all_circles(img,c,r,rad);
title(sprintf('%d circles, threshold %f', size(c,1), thres));


% recompute 3d-indices of maxima
s = [height width levels];
%% ================ Part 3: draw blobs on image ===========================
figure
rad = rad / max(rad);

hist(rad,10);