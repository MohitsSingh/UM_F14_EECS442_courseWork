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
%  
%  This is the normalized version.
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

fid=fopen('q3Output_norm.txt','wt');
fprintf(fid,'No.iter\t\t'); 
fprintf(fid,'No.outliers\t\t'); 
fprintf(fid,'fitting error\t\n'); 

%% ===================== Part 2: n iteration ==============================
max = 0;
H_max = zeros(3,3);
disMatrix = zeros(k,1);

[p1_set, p2_set] = readPoints('200points.txt');
p1_set = [p1_set, ones(size(p1_set,1),1)];
p2_set = [p2_set, ones(size(p2_set,1),1)];

M1 = normMatrix(p1_set);
M2 = normMatrix(p2_set);

p1_norm = (M1 * p1_set')';
p2_norm = (M2 * p2_set')';

for i = 1:4
    % get sample point set
    index = randi(200, 1, 4);
    p1 = [p1_norm(index(1),:);p1_norm(index(2),:);...
                            p1_norm(index(3),:);p1_norm(index(4),:)];
    p2 = [p2_norm(index(1),:);p2_norm(index(2),:);...
                            p2_norm(index(3),:);p2_norm(index(4),:)];

    % compute H for the given set
    [H,H_denorm] = Homography_norm(p1, p2, M1, M2);

    p1_map =  (H * p1_norm')';
    homo = repmat(p1_map(:,3), 1,3);
    p1_map = p1_map ./ homo;
    dis = sum((p1_map - p2_norm).* (p1_map - p2_norm),2).^0.5;
    
    
    p1_map_denorm =  (H_denorm * p1_set')';
    homo_denorm = repmat(p1_map_denorm(:,3), 1,3);
    p1_map_denorm = p1_map_denorm ./ homo_denorm;
    dis_denorm = sum((p1_map_denorm - p2_set).* (p1_map_denorm...
                                    - p2_set),2).^0.5;
    disMatrix(i) = sum(dis_denorm);
    
    error = disMatrix(i) / size(p1_set,1);
    
    % support
    I = find(dis < threshold);
    % print result to the file
    
    fprintf(fid,'%i\t\t\t%i\t\t\t\t%f\n',i,size(I,1),error); 

    % if find more support than the current one: store the H
    if size(I,1) >= max
        inliers = I;
        max = size(I,1);
        H_max = H;
        H_max_denorm = H_denorm;
       support = I;
       wrong = find(threshold <= dis);
    end
end
%% ===================== re-estimate H ====================================
% collect inlier points

p1_in = zeros(size(inliers,1),3);
p2_in = zeros(size(inliers,1),3);

j = 1;

for i = 1:size(inliers)
    p1_in(j,:) = p1_set(inliers(i),:);
    p2_in(j,:) = p2_set(inliers(i),:);
    j = j+1;
end
% calculate H

H_final = Homography(p1_in, p2_in)
p1_map_final =  (H_final * p1_set')';
homo_final = repmat(p1_map_final(:,3), 1,3);
p1_map_final = p1_map_final ./ homo_final;
dis_final = sum((p1_map_final - p2_set).* (p1_map_final - p2_set),2).^0.5;
error = sum(dis_final)/ 200
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
