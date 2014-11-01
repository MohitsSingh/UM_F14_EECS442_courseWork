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

%  This is the un-nomalized version.
%% Initialization

clear; close all; clc
%% ===================== Part 1: k computation ============================

% set parameters
% selects a sample set with inliers only with probability p=0.95
p = 0.95; 
threshold = 5.99^0.5 * 0.5;
% w^n is probability that all points inliers
n = 4;
% 1-0.12 inliers probability
w = 0.88;

iterResult = zeros(4,2);

% compute k
k = log(1 - p) / log(1 - w^n);
k = ceil(k);

% prepare file for writing

fid=fopen('q3Output.txt','wt');
fprintf(fid,'No.iter\t\t'); 
fprintf(fid,'No.outliers\t\t'); 
fprintf(fid,'fitting error\t\n'); 

%% ===================== Part 2: n iteration ==============================
max = 0;
H_max = zeros(3,3);
[p1_set, p2_set] = readPoints('200points.txt');
p1_set = [p1_set, ones(size(p1_set,1),1)];
p2_set = [p2_set, ones(size(p2_set,1),1)];

disMatrix = zeros(k,1);

for i = 1:4
    error = 0;

    % get sample point set
    index = randi(200, 1, 4);
    p1 = [p1_set(index(1),:);p1_set(index(2),:);...
                            p1_set(index(3),:);p1_set(index(4),:)];
    p2 = [p2_set(index(1),:);p2_set(index(2),:);...
                            p2_set(index(3),:);p2_set(index(4),:)];

    % compute H for the given set
    H = Homography(p1, p2);

    p1_map =  (H * p1_set')';
    homo = repmat(p1_map(:,3), 1,3);
    p1_map = p1_map ./ homo;
    dis = sum((p1_map - p2_set).* (p1_map - p2_set),2).^0.5;
    disMatrix(i) = sum(dis);

    % support
    I = find(dis < threshold);
    % print result to the file
    fprintf(fid,'%i\t\t\t%i\t\t\t%f\n',i,size(I,1),disMatrix(i)); 

    % if find more support than the current one: store the H
    if size(I,1) >= max
        max = size(I,1);
        H_max = H;
       support = I;
       wrong = find(threshold <= dis);
    end
end

%% ===================== Part 3: ploting ==================================

% store parameter
N_support = size(support,1);
N_wrong = size(wrong,1);
 
figure(1);
% read img 1
img1 = imread('garden1.jpg');
imshow(img1);
hold on;
% draw support
for i = 1:N_support
    x = p1_set(support(i),1);
    y = p1_set(support(i),2);
    plot(x,y,'xg','linewidth',1);  
end
% draw wrong
for i = 1:N_wrong
    x = p1_set(wrong(i),1);
    y = p1_set(wrong(i),2);
    plot(x,y,'or','linewidth',1);  
end
 
hold off;
figure(2);
% read img 1
img2 = imread('garden2.jpg');
imshow(img2);
hold on;
% draw support
for i = 1:N_support
    x = p2_set(support(i),1);
    y = p2_set(support(i),2);
    plot(x,y,'xg','linewidth',1);  
end
% draw wrong
for i = 1:N_wrong
    x = p2_set(wrong(i),1);
    y = p2_set(wrong(i),2);
    plot(x,y,'or','linewidth',1);  
end
 
hold off;