%% EECS 442 - HW 05 - Q2a Object Recognition

%  Declaration
%  ------------
%  Date: 2014 / 11 / 28
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  trainBOW(inputDir1,inputDir2, k);
%  testBOW(inputDir1,inputDir2, ...
%           codewords, trainFeatures,trainLabels,k)

%  Instructions
%  ------------
%  Implement the following BoW algorithm: The BoW process involves two 
%  stages - training and testing.
 
%% Initialization
clc;close all; clear;

run('vlfeat/toolbox/vl_setup')
faceDir = 'faces/image_00';
carDir = 'cars/image_00';
kBOW = [3,5,10];
accuracy = zeros(1,size(kBOW,2));
% train
for i = 1:size(kBOW,2)
    tic
[codewords,trainFeatures, trainLabels]= trainBOW(faceDir,carDir, kBOW(i));
    toc
% test
    tic
[predictLabels,testLabels] = testBOW(faceDir,carDir, ...
                            codewords, trainFeatures,trainLabels,kBOW(i));
    toc
accuracy(i) = mean(predictLabels(:) == testLabels(:));

fprintf('Test Accuracy:  %f%%\n', 100 * accuracy(i));
end
plot(kBOW, accuracy, 'r-');