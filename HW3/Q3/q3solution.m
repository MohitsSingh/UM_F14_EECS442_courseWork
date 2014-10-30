
%% EECS 442 - HW 02 - Q3 Fundamental matrix and Image rectification 

%  Declaration
%  ------------
%  Date: 2014 / 10 / 20
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  FMatrix(pathdata1,pathdata2,pathimg1,pathimg2)
%  FMatrix_normalization(pathdata1,pathdata2,pathimg1,pathimg2)
%  imageRect(pathdata1,pathdata2,pathimg1,pathimg2)

%  Instructions
%  ------------
%  3.1 Corner Extraction
%  Extract the feature correspondences required for calibration. In other 
%  words, first find the scene coordinates of the square corners of the 
%  calibration grid. Next, find the corresponding pixel coordinates in the 
%  images.

%  3.2 Affine calibration
%  Using your measured feature correspondences as input, write code which 
%  constructs the linear system of equations and solves for the camera 
%  parameters which minimizes the least-squares error.
%% Initialization

clear; close all; clc
%% ================= Part 1: Corner Extraction ============================
fprintf('Running HW2 Q3.1 exercise ... \n');
fprintf('Extracting calibration grids...');
scene = [
    0    , 0    ,      0,      1;
    17.5 , 0    ,      0,      1;
    175.0, 0    ,      0,      1;
    192.5, 0    ,      0,      1;
    70   , 70   ,      0,      1;
    87.5 , 70   ,      0,      1;
    87.5 , 87.5 ,      0,      1;
    70   , 87.5 ,      0,      1;
    0    , 192.5,      0,      1;
    17.5 , 192.5,      0,      1;
    175.0, 192.5,      0,      1;
    192.5, 192.5,      0,      1;
    0    , 0    ,      9.5,    1;
    17.5 , 0    ,      9.5,    1;
    175.0, 0    ,      9.5,    1;
    192.5, 0    ,      9.5,    1;
    70   , 70   ,      9.5,    1;
    87.5 , 70   ,      9.5,    1;
    87.5 , 87.5 ,      9.5,    1;
    70   , 87.5 ,      9.5,    1;
    0    , 192.5,      9.5,    1;
    17.5 , 192.5,      9.5,    1;
    175.0, 192.5,      9.5,    1;
    192.5, 192.5,      9.5,    1;
];
scene = scene';
pixel_1 = zeros(3,12);
pixel_2 = zeros(3,12);

% read img
img1 = imread('1.JPG');
edges1 = edge(rgb2gray(img1),'canny');
% comput pixel base
figure(1);
imshow(img1);
hold on;
fprintf('Here get points for the first img ... \n');
[x1, y1] = ginput(12);

for i = 1:12
    pixel_1(1,i) = x1(i);
    pixel_1(2,i) = y1(i);
    pixel_1(3,i) = 1;
    plot(x1(i),y1(i),'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);
end
hold off;

img2 = imread('2.JPG');
edges2 = edge(rgb2gray(img2),'canny');
% comput pixel base
figure(2);
imshow(img2);
hold on;
fprintf('Here get points for the second img ... \n');
[x2, y2] = ginput(12);

for i = 1:12
    pixel_2(1,i) = x2(i);
    pixel_2(2,i) = y2(i);
    pixel_2(3,i) = 1;
    plot(x2(i),y2(i),'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);
end

pixel = [pixel_1, pixel_2];
%% ================= Part 2: Camera calibration ===========================
fprintf('Computing camera matrix ... \n');
cameraM = pixel * pinv(scene)


%% ================= Part 3: Compute error ================================
pixel_predict = cameraM * scene;
diff = pixel_predic - pixel;
err = mean(sqrt(sum(sum(diff.*diff))));