function [HL,HR,err] = imageRect(pathdata1,pathdata2,pathimg1,pathimg2)
% get fundamental matrix
F = FMatrix_normalization(pathdata1,pathdata2,pathimg1,pathimg2);
img1 = imread(pathimg1);
img2 = imread(pathimg2);

% calculate epipoles
[U, D, V] = svd (F);
epL = V(:,end); % last column of V
epL = epL/epL(3);
[U, D, V] = svd(F');
epR = V(:,end);
epR = epR/epR(3);

% map epi_prime to [1,0,1]
% x0 is center of the image
pc = [size(img2,2)/2 ; size(img2,1)/2];
TH=[
    1, 0, pc(1);
    0, 1, pc(2);
    0, 0, 1
    ];
epR_prime = TH * epR;
len = sqrt(epR_prime(1)^2+epR_prime(2)^2);
sine = epR_prime(2) / len;
cose = epR_prime(1) / len;
RH=[
    cose, -sine, 0;
    sine, cose, 0;
    0, 0, 1
    ];
% map e_prime to the x-axis at location [length,0,1]
H1=RH * TH;  
% send epipole to infinity
H2 = [
    1 0 0; 
    0 1 0; 
    -1/len 0 1
    ];
% transformation for one image
HR = H2*H1;

% find H to align epipolar lines
% calculate M
% [e'_]xM = F
exM = pinv([0, -epR(3), epR(2); epR(3),0,-epR(1);-epR(2),epR(1),0]);
M = exM * F;
H0 = HR * M;
% find HA =  I + HR * epR * a'
[X1,X2] =  readTextFiles(pathdata1,pathdata2); 
X2_hat = HR * X2;
X1_hat = H0 * X1;
X1_hat = X1_hat./repmat(X1_hat(3,:),3,1);
X2_hat = X2_hat./repmat(X2_hat(3,:),3,1);
A = X1_hat';
b = X2_hat(1,:)';
% use the method solving least square parameter
lsp = pinv(A) * b;
HA = [lsp(1),lsp(2),lsp(3);0 1 0;0 0 1];
% get H
HL = HA * H0;

% apply transform and find errors
X1H = HL*X1;
X1H = X1H./repmat(X1H(3,:),3,1);
X2H = HR*X2;
X2H = X2H./repmat(X2H(3,:),3,1);
err = sum((X1H(1:2,:)-X2H(1:2,:)).^2);
err = mean(sqrt(err));