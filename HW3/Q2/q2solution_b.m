
%% EECS 442 - HW 03 - Q2 Single View Geometry 

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
%  b. Camera calibration
%  Identify a sufficient set of vanishing lines on the ground plane and 
%  the plane on which the letter A exists (plane-B). Use these vanishing 
%  lines to verify numerically that the ground plane is orthogonal to the 
%  plane-B

%% Initialization

clear; close all; clc

k = [
    2448,   0,      1253;
    0,      2438,   986;
    0,      0,      1
]
%% ================= Part 1: compute normal ===============================
fprintf('Running HW3 Q2.b exercise ... \n');
fprintf('Computing normal, first ground and second plane-B...');

% compute 
n_g = computeNorm(k);
n_b = computeNorm(k);

orthognal = n_g' * n_b;