function [F,dist1,dist2] = FMatrix(pathdata1,pathdata2,pathimg1,pathimg2) 
% EECS 442 HW2 Q3a
% fundenmantal matrix without normalization

% load feature points from two images. column wise data
% format: dimention(3) * N
[X1,X2] = readTextFiles(pathdata1,pathdata2);

% construction of W, every row is a set of corresponding points
W=ones(9,size(X1,2)); 
W(1,:) = X2(1,:).*X1(1,:);
W(2,:) = X2(1,:).*X1(2,:);
W(3,:) = X2(1,:);
W(4,:) = X2(2,:).*X1(1,:);
W(5,:) = X2(2,:).*X1(2,:);
W(6,:) = X2(2,:);
W(7,:) = X1(1,:);
W(8,:) = X1(2,:);
% calculate SVD of A
W=W';
[U, D, V] = svd (W);
f = V(:,end); % f is the last column of V
F = reshape(f,3,3);
F = F';
[U, D, V] = svd(F);
D(:,3:end) = 0; % only use the first two columns
F = U * D * V';

% calculate distances
% epipolar lines for X1
F = F';
l1 = F * X2; % 3-3 * 3-n
% epipolar lines for X2
l2 = F' * X1;

% distance between X1 and l1
temp = abs(l1(1,:).*X1(1,:)+l1(2,:).*X1(2,:)+l1(3,:));
dist1 = temp./(l1(1,:).^2+l1(2,:).^2).^.5;
dist1 = mean(dist1(:));
% distance between X2 and l2
temp = abs(l2(1,:).*X2(1,:)+l2(2,:).*X2(2,:)+l2(3,:));
dist2 = temp./(l2(1,:).^2+l2(2,:).^2).^.5;
dist2 = mean(dist2(:));

% draw feature points and epipolar lines
figure;
img1 = imread(pathimg1);
imshow(img1);
hold on;
for i=1:size(X1,2)
	x = X1(1,i)-50:X1(1,i)+50;
	y = -(l1(1,i).*x+l1(3,i))./l1(2,i);
	plot(x,y,'b');
end
plot(X1(1,:),X1(2,:),'r*');
hold off;

figure;
img2 = imread(pathimg2);
imshow(img2);
hold on;
plot(X2(1,:),X2(2,:),'ro');
for i=1:size(X2,2)
	x = X2(1,i)-20:X2(1,i)+20;
	y = -(l2(1,i).*x+l2(3,i))./l2(2,i);
	plot(x,y,'b');
end
hold off;