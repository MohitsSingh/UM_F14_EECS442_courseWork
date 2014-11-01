function [norm] = normMatrix(p)
%centroid
transP = [-mean(p(:,1)); -mean(p(:,2)); 1];
% Isotropic scaling
transform = repmat(transP', size(p,1),1);
length = sqrt(sum((p+transform).^2,2));
scaleP = sqrt(2)./mean(length);
% transform matrix
transM = eye(3,3);
transM(:,3) = transP;

scaleM = eye(3,3);
scaleM(1,1) = scaleP;
scaleM(2,2) = scaleP;

norm = scaleM * transM;

end