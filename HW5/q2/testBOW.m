function [predictLabels,testLabels] = testBOW(inputDir1,inputDir2, ...
                            codewords, trainFeatures,trainLabels,k)
% num of images used 
N = 50;
skip = 40;
% generate histogram vector
    % (numImages,k): ith image has histogram(i,j) codeword j.
testFeatures = zeros(2*N, k);
predictLabels = zeros(2*N,1);
testLabels = zeros(2*N,1);
% run the k-means
kdtree = vl_kdtreebuild(codewords);
kdtree_classify = vl_kdtreebuild(trainFeatures');
% repeat the above algorithm, regenerate all SIFT for further computation
for i = 1+skip:N+skip
    for j = 1:2
        if j == 1
            figureName = 'test_faces_';
            imgDir = inputDir1;
        else
            figureName = 'test_cars_';
            imgDir = inputDir2;
        end
        figureName = strcat(figureName,num2str(k));
        figureName = strcat(figureName,'_');
        curIndex = (j-1)*N+i-skip;
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
            %forHist(p) = index;
            % increase the corresponding entries in the histogram
            testFeatures(curIndex,index) = ...
                testFeatures(curIndex,index)+ 1;
        end
        testFeatures(curIndex,:) = testFeatures(curIndex,:) /...
                  sum(testFeatures(curIndex,:));
        [index_classify, distance] =...
                vl_kdtreequery(kdtree_classify, trainFeatures', ...
                    testFeatures(curIndex,:)','NumNeighbors', 1) ;
        testLabels(curIndex,:) = j;
        predictLabels(curIndex,:) = trainLabels(index_classify,:);
        %hist(forHist);
        %bar(hist(forHist) ./ sum(hist(forHist)));
        %bar(testFeatures(curIndex,:));
        %figureName = strcat(figureName,num2str(i));
        %print('-f1', '-djpeg', '-r300', figureName);
        %close all;
    end
end

end