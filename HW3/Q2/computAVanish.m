function a = computAVanish(v, u)
% A function computing a from two vanishing points, so to express:
%       u'wv = 0
% as
%       a'w = 0

%a = [
%    v(1)*u(1); 
%    v(1)*u(2) + v(2)*u(1);
%    v(2)*u(2); 
%    v(1)*u(3) + v(3)*u(1);
%    v(2)*u(3) + v(3)*u(2);
%    v(3)*u(3); 
%]

a = [
    v(1)*u(1) + v(2)*u(2);
    v(1) +  u(1);
    v(2) +  u(2);
    1
]
end

