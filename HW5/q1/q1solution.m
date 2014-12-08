
%% EECS 445 - HW 05 - Q1 Clustering

%  Declaration
%  ------------
%  Date: 2014 / 12 / 1
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  kmean_train
%  kmean_assign

%  Instructions
%  ------------
%  Implement the k-means clustering in RGB space as discussed in lecture 
%  (also in FP - Algorithm 14.5 in the first edition or Algorithm 6.3 in 
%  second edition). Test your implementation on segmenting the image 
%  segmentation.jpg using k = 3. Initialize the algorithm by randomly 
%  picking k points. Try at least 5 different random initializations and 
%  show corresponding segmentation results. Describe your implementation 
%  and attach your code as an appendix. Also, comment on your different 
%  segmentation results. 

%% Initialization
clear; close all; clc
%% ============= Part 0: run train and assignfunc =========================

mu = kmean_train;
kmean_assign(mu);