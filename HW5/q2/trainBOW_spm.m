function [codewords,trainFeatures, trainLabels] = ...
        trainBOW_spm(inputDir1,inputDir2, k)
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
        % split the image
        [f,d] = vl_sift(I);
        % combine all the features
        featureMat = [featureMat; f'];
    end
end

% generate histogram vector
    % (numImages,k): ith image has histogram(i,j) codeword j.
    % (:,:,1): for the whole picture
    % (:,:,2-5): partial pictures
trainFeaturesMat = zeros(2*N, k,5);
trainLabels = zeros(2*N,1);
% run the k-means
[codewords, assignments] = vl_kmeans(featureMat', k);
kdtree = vl_kdtreebuild(codewords);
trainFeatures = [];
% repeat the above algorithm, regenerate all SIFT for further computation
for i = 1:N
    for j = 1:2
        if j == 1
            imgDir = inputDir1;
        else
            imgDir = inputDir2;
        end
        %figureName = strcat(figureName,num2str(k));
        %figureName = strcat(figureName,'_');
        curIndex = (j-1)*N+i;
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
            trainFeaturesMat(curIndex,index,1) = ...
                trainFeaturesMat(curIndex,index,1)+ 1;
        end
        trainFeaturesMat(curIndex,:,1) = trainFeaturesMat(curIndex,:,1) /...
                    sum(trainFeaturesMat(curIndex,:,1));
        % for spacial bins in the image
        m = size(I,1);
        n = size(I,2);

        n = size(I,2);
        subI = zeros(m/2,n/2,4);
        subI(1:m/2,1:n/2,1) = I(1:m/2,1:n/2);
        subI(1:m/2,1:n/2,2) = I(1:m/2,n/2+1:n);
        subI(1:m/2,1:n/2,3) = I(m/2+1:m,1:n/2);
        subI(1:m/2,1:n/2,4) = I(m/2+1:m,n/2+1:n);
        %smallM = m/2;
        %largeM = m/2+1;
        %smallN = n/2;
        %largeN = n/2+1;
        %if (mod(m,2)==1)
        %    smallM = floor(m/2);
        %    largeM = ceil(m/2);
        %end
        %if (mod(n,2)==1)
        %    smallN = floor(n/2);
        %    largeN = ceil(n/2);
        %end        
        %subI = zeros(smallM,smallN,4);
        %subI(1:smallM,1:smallN,1) = I(1:smallM,1:smallN);
        %subI(1:smallM,1:n-largeN+1,2) = I(1:smallM,largeN:n);
        %subI(1:m-largeM+1,1:smallN,3) = I(largeM:m,1:smallN);
        %subI(1:m-largeM+1,1:n-largeN+1,4) = I(largeM:m,largeN:n);
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
                trainFeaturesMat(curIndex,index,e+1) = ...
                    trainFeaturesMat(curIndex,index,e+1)+ 1;
            end
            newFeature = [newFeature trainFeaturesMat(curIndex,:,e+1)];
        end
        % Concatenate histogram vectors in a fixed order
        newFeature = newFeature / sum(newFeature);
        newFeature = [newFeature trainFeaturesMat(curIndex,:,1)];
        newFeature = newFeature / 2;
        trainFeatures = [trainFeatures; newFeature];
        trainLabels(curIndex,:) = j;
    end
end

end