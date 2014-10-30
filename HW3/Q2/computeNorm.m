function n = computeNorm(k)
% A function computing vainshing line from vanishing points, and then
% compute the normal for the plane using n = k' * l

% Get vanishing points
v1 = getVanishingPoint('1.jpg');
v2 = getVanishingPoint('1.jpg');

% Compute vanishing line: (y1 ? y2)x + (x2 ? x1)y + (x1y2 ? x2y1) = 0
a = v1(2) - v2(2);
b = v2(1) - v1(1);
c = v1(1) * v2(2) - v2(1) * v1(2);

l = [a;b;c] % 3 * 1, vanishing line
n = k' * l;
n = n/norm(n);

end

