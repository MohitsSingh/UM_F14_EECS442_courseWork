
%% EECS 442 - HW 03 - Q2 Single View Geometry 

%  Declaration
%  ------------
%  Date: 2014 / 10 / 20
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  getVanishingPoint(im)
%  computAVanish(u, v)

%  Instructions
%  ------------
%  a. Camera calibration
%  Identify a set of N vanishing points from the image 1. Assume the camera
%  has zero skew and square pixels, with no distortion.

%% Initialization

clear; close all; clc
%% ================= Part 1: vanishing points Extraction ==================
fprintf('Running HW3 Q2.a exercise ... \n');
fprintf('Get 3 vanishing points for image 1...');

v1 = getVanishingPoint('1.jpg');
v2 = getVanishingPoint('1.jpg');
v3 = getVanishingPoint('1.jpg');

%% ================= Part 2: Camera calibration ===========================
fprintf('Computing camera matrix ... \n');

% all a: 4 * 1
a1 = computAVanish(v1, v2);
a2 = computAVanish(v1, v3);
a3 = computAVanish(v2, v3);
% a: 6 * 3
a = [a1, a2, a3];
a = a';

[U, D, V] = svd (a);
w = V(:,end); % f is the last column of V
% constraint  on square and zero-skew matrix
w = [
    w(1), 0, w(2);
    0, w(1), w(3);
    w(2), w(3), w(4);
]

% compute k: w = 
k = inv(chol(w));
k = k / k(3,3);