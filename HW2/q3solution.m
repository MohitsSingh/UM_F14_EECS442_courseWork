
%% EECS 442 - HW 02 - Q3 Fundamental matrix and Image rectification 

%  Declaration
%  ------------
%  Date: 2014 / 10 / 03
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  FMatrix(pathdata1,pathdata2,pathimg1,pathimg2)
%  FMatrix_normalization(pathdata1,pathdata2,pathimg1,pathimg2)
%  imageRect(pathdata1,pathdata2,pathimg1,pathimg2)

%  Instructions
%  ------------
%  3.1 Fundamental Matrix
%  Implement both the linear least squares versionof the eight-point 
%  algorithm and its normalized version. In both cases, enforce the 
%  rank-two constraint for the fundamental matrix via singular value 
%  decomposition.
%  Return distance, fundamental distance, and figure showing epipolar
%  lines and the feature points for each image pair.

%  3.2 Stereo Rectification
%  perform image rectification on the two images. While choosing the 
%  matching transform to be applied on the image, make sure the algorithm 
%  minimizes the distance error between transformed pixels. Return H 
%  transforms and distance error.
%% Initialization

clear; close all; clc
%% ================= Part 1: fundamental matrix ===========================
fprintf('Running HW2 Q3.1 exercise ... \n');
fprintf('Computing FM and distances for set 1...');
% without normalization
[F1,dist1_1,dist1_2]= FMatrix(...
    'set1/pt_2D_1.txt','set1/pt_2D_2.txt',...
    'set1/image1.jpg','set1/image2.jpg')
[F1_norm,dist1_1_norm,dist1_2_norm]=FMatrix_normalization(...
    'set1/pt_2D_1.txt','set1/pt_2D_2.txt',...
    'set1/image1.jpg','set1/image2.jpg')


fprintf('Computing FM and distances for set 2...');
% without normalization
[F2,dist2_1,dist2_2]= FMatrix(...
    'set2/pt_2D_1.txt','set2/pt_2D_2.txt',...
    'set2/image1.jpg','set2/image2.jpg')
[F2_norm,dist2_1_norm,dist2_2_norm]=FMatrix_normalization(...
    'set2/pt_2D_1.txt','set2/pt_2D_2.txt',...
    'set2/image1.jpg','set2/image2.jpg')

%% ================= Part 2: stereo fectification =========================
fprintf('Running HW2 Q3.2 exercise ... \n');
fprintf('Performing rectification for set 1...');
[HL_1 HR_1 err_1] = imageRect('set1/pt_2D_1.txt','set1/pt_2D_2.txt',...
                'set1/image1.jpg','set1/image2.jpg')
fprintf('Performing rectification for set 2...');
[HL_2 HR_2 err_2] = imageRect('set2/pt_2D_1.txt','set2/pt_2D_2.txt',...
                'set2/image1.jpg','set2/image2.jpg')

