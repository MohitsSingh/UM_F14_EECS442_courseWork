function [codewords,trainFeatures, trainLabels] = ...
        trainBOW(inputDir1,inputDir2, k)
% num of images used 
N = 40;
featureMat = [];
for i = 1:N
    for j = 1:2
        if j == 1
            imgDir = inputDir1;
        else
            imgDir = inputDir2;
        end
        if(i < 10)
            imgDir = strcat(imgDir, '0');
        end
        imgDir = strcat(imgDir, num2str(i));
        imgDir = strcat(imgDir, '.jpg');
        I = imread(imgDir);
        I = single(rgb2gray(I));
        [f,d] = vl_sift(I);
        % combine all the features
        featureMat = [featureMat; f'];
    end
end

% generate histogram vector
    % (numImages,k): ith image has histogram(i,j) codeword j.
trainFeatures = zeros(2*N, k);
trainLabels = zeros(2*N,1);
% run the k-means
[codewords, assignments] = vl_kmeans(featureMat', k);
kdtree = vl_kdtreebuild(codewords);

% repeat the above algorithm, regenerate all SIFT for further computation
for i = 1:N
    for j = 1:2
        if j == 1
            figureName = 'train_faces_';
            imgDir = inputDir1;
        else
            figureName = 'train_cars_';
            imgDir = inputDir2;
        end
        figureName = strcat(figureName,num2str(k));
        figureName = strcat(figureName,'_');
        curIndex = (j-1)*N+i;
        if(i < 10)
            imgDir = strcat(imgDir, '0');
        end
        imgDir = strcat(imgDir, num2str(i));
        imgDir = strcat(imgDir, '.jpg');
        I = imread(imgDir);
        I = single(rgb2gray(I));
        [f,d] = vl_sift(I);
        % compute how many features is in the picture
        numFeature = size(f,2);
        for p = 1: numFeature
            % get the index of every feature
            [index, distance] =...
                vl_kdtreequery(kdtree, codewords, f(:,p)) ;
            trainFeatures(curIndex,index) = ...
                trainFeatures(curIndex,index)+ 1;
        end
        trainLabels(curIndex,:) = j;
        trainFeatures(curIndex,:) = trainFeatures(curIndex,:) /...
                    sum(trainFeatures(curIndex,:));
        %bar(trainFeatures(curIndex,:));
        %figureName = strcat(figureName,num2str(i));
        %print('-f1', '-djpeg', '-r300', figureName);
        %close all;
    end
    
end


end