function [H, H_denorm] = Homography_norm(p1, p2, M1, M2)

% normalization
% centroid

% get number of points
n = size(p1,1);
% construct homogeneous x and x'
x = p1;
x_prime = p2;

% construct A
A = [];
for i = 1:n
    %construct Ai with xi',yi',wi' and xi
    xi_prime = x_prime(i,1);
    yi_prime = x_prime(i,2);
    wi_prime = x_prime(i,3);
    xi = x(i,:);
    Ai = [  0, 0, 0,        -wi_prime * xi,   yi_prime * xi ;
            wi_prime * xi   0, 0, 0,          -xi_prime * xi];
    A = [A; Ai];
end
%use svd decomposition
[U,D,V] = svd(A);
%H is the last column of V
H = reshape(V(:,end),3,3)';
H_denorm  = M2 \ H * M1;
H_denorm  = H_denorm / H_denorm(3,3);
H = H / H(3,3);

end