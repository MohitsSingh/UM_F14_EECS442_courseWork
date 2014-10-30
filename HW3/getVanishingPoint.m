function v = getVanishingPoint(im)
% An interactive function that facilitates computing a 
% vanishing point given an image 'im' as input.
% Usage: Select two points from the first line and then two more for the
% second line.
% Output v is a vanishing point such that: (v(1),v(2)) = (x,y)

if  size(im,3) == 1
    figure(10), imshow(im);
else
    figure(10), imagesc(im);
end

[x,y] = getpts;
% l1 = [m c] for y=mx+c
l1(1) = (y(2)-y(1))/(x(2)-x(1));
l1(2) = -l1(1)*x(1) + y(1);

% l2 = [m c] for y=mx+c
l2(1) = (y(4)-y(3))/(x(4)-x(3));
l2(2) = -l2(1)*x(3) + y(3);

% compute vanishing point
v(1) = (l2(2) - l1(2))/(l1(1) - l2(1));
v(2) = l1(1)*v(1) + l1(2);

return

