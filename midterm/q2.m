%% EECS 442 - Midterm - Q2 Computing H 

%  Declaration
%  ------------
%  Date: 2014 / 10 / 29
%  Author: WU Tongshuang, 40782306

%  Instructions
%  ------------
%  Write a function Homography that takes a set of at least 4 image point 
%  correspondences between two images (manually selected) and returns an 
%  estimate of the homographic transformation between the images. Use the 
%  DTL algorithm to compute the homography.

%% Initialization

clear; close all; clc

%readPoints
[p1, p2] = readPoints('4points.txt');
p1 = [p1, ones(size(p1,1),1)];
p2 = [p2, ones(size(p2,1),1)];

H = Homography(p1, p2)