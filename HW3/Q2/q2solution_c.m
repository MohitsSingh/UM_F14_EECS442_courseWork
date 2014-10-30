
%% EECS 442 - HW 03 - Q2 Single View Geometry 

%  Declaration
%  ------------
%  Date: 2014 / 10 / 20
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  getVanishingPoint(im)

%  Instructions
%  ------------
%  c. Camera calibration
%  Assume the camera rotates but no translation takes place. Assume the 
%  internal camera parameters remain unchanged. An image 2 of the same 
%  scene is taken. Use vanishing points to compute camera rotation matrix.
%  Report derivation and numerical results.

%% Initialization

clear; close all; clc
%% ================= Part 1: vanishing points Extraction ==================
fprintf('Running HW3 Q2.a exercise ... \n');
fprintf('Get 3 vanishing points for image 1 and 2...');

v1_1 = getVanishingPoint('1.jpg');
v1_2 = getVanishingPoint('1.jpg');
v1_3 = getVanishingPoint('1.jpg');

v1_1 = [v1_1 / norm(v1_1),1];
v1_2 = [v1_2 / norm(v1_2),1];
v1_3 = [v1_3 / norm(v1_3),1];

v2_1 = getVanishingPoint('2.jpg');
v2_2 = getVanishingPoint('2.jpg');
v2_3 = getVanishingPoint('2.jpg');

v2_1 = [v2_1 / norm(v2_1),1];
v2_2 = [v2_2 / norm(v2_2),1];
v2_3 = [v2_3 / norm(v2_3),1];

%% ================= Part 2: compute rotation M ===========================
fprintf('Computing rotation matrix ... \n');

% image 1 vanishing points
v1 = [v1_1', v1_2', v1_3']; % dimention * #points
% image 2 vanishing points:
v2 = [v2_1', v2_2', v2_3']; % dimention * #points
% v2 = R * v1

R = v2 * pinv(v1)