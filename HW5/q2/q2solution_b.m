%% EECS 442 - HW 05 - Q2a Object Recognition

%  Declaration
%  ------------
%  Date: 2014 / 11 / 28
%  Author: WU Tongshuang, 40782306

%  used helper function
%  --------------------
%  trainBOW_spm(inputDir1,inputDir2, k);
%  testBOW_spm(inputDir1,inputDir2, ...
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
kBOW = 3;
% train
[codewords,trainFeatures, trainLabels]= trainBOW_spm(faceDir,carDir, kBOW);
% test
[predictLabels,testLabels] = testBOW_spm(faceDir,carDir, ...
                            codewords, trainFeatures,trainLabels,kBOW);
                        
accuracy = 100 * mean(predictLabels(:) == testLabels(:));
fprintf('Test Accuracy:  %f%%\n', accuracy);