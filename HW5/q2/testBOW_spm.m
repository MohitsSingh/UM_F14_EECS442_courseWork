function [predictLabels,testLabels] = testBOW_spm(inputDir1,inputDir2, ...
                            codewords, trainFeatures,trainLabels,k)
% num of images used 
N = 50;
skip = 40;
% generate histogram vector
    % (numImages,k): ith image has histogram(i,j) codeword j.
testFeaturesMat = zeros(2*N, k,5);
testFeatures = [];
prediectLabels = zeros(2*N,1);
testLabels = zeros(2*N,1);
% run the k-means
kdtree = vl_kdtreebuild(codewords);
kdtree_classify = vl_kdtreebuild(trainFeatures');
% repeat the above algorithm, regenerate all SIFT for further computation
for i = 1+skip:N+skip
    for j = 1:2
        if j == 1
            imgDir = inputDir1;
        else
            imgDir = inputDir2;
        end
        %figureName = strcat(figureName,num2str(k));
        %figureName = strcat(figureName,'_');
        curIndex = (j-1)*N+i-skip;
        if(i < 10)
            imgDir = strcat(imgDir, '0');
        end
        imgDir = strcat(imgDir, num2str(i));
        imgDir = strcat(imgDir, '.jpg');
        I = imread(imgDir);
        I = rgb2gray(I);
        wholeI = single(I);
        % for the whole picture
        [f,d] = vl_sift(wholeI);
        % compute how many features is in the picture
        numFeature = size(f,2);
        for p = 1: numFeature
            % get the index of every feature
            [index, distance] =...
                vl_kdtreequery(kdtree, codewords, f(:,p)) ;
            testFeaturesMat(curIndex,index,1) = ...
                testFeaturesMat(curIndex,index,1)+ 1;
        end
        testFeaturesMat(curIndex,:,1) = testFeaturesMat(curIndex,:,1) /...
                    sum(testFeaturesMat(curIndex,:,1));
        % for spacial bins in the image
        m = size(I,1);
        n = size(I,2);

        n = size(I,2);
        subI = zeros(m/2,n/2,4);
        subI(1:m/2,1:n/2,1) = I(1:m/2,1:n/2);
        subI(1:m/2,1:n/2,2) = I(1:m/2,n/2+1:n);
        subI(1:m/2,1:n/2,3) = I(m/2+1:m,1:n/2);
        subI(1:m/2,1:n/2,4) = I(m/2+1:m,n/2+1:n);
        newFeature = [];
        for e = 1:4
            curI = subI(:,:,e);
            curI = single(curI);
            [f,d] = vl_sift(curI);
            numFeature = size(f,2);
            for p = 1: numFeature
                % get the index of every feature
                [index, distance] =...
                    vl_kdtreequery(kdtree, codewords, f(:,p));
                testFeaturesMat(curIndex,index,e+1) = ...
                    testFeaturesMat(curIndex,index,e+1)+ 1;
            end
            newFeature = [newFeature testFeaturesMat(curIndex,:,e+1)];
        end
        newFeature = newFeature / sum(newFeature);
        newFeature = [newFeature testFeaturesMat(curIndex,:,1)];
        newFeature = newFeature / 2;
        testFeatures = [testFeatures; newFeature];
        testLabels(curIndex,:) = j;
        % compute how many features is in the picture
        [index_classify, distance] =...
                vl_kdtreequery(kdtree_classify, trainFeatures', ...
                    newFeature','NumNeighbors', 1) ;
        predictLabels(curIndex,:) = trainLabels(index_classify,:);
    end
end

end