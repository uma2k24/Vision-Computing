function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

% Compute camera center w/ SVD
[~, ~, V] = svd(P);
center = V(:,end); 
center = center(1:3)./center(4);

% K (intrinsic) and R (rotation) computation via QR decomposition
rp = [0,0,1; 0,1,0; 1,0,0;];

rp = rp * P(:,1:3);
rp = rp';
[Q,R] = qr(rp);

Q = rp * Q';
R = rp * R' * rp;

neg = -any((R<0) & (abs(R)>1e-4));
neg(neg == 0) = 1;

K = R * diag(neg); % K is upper right triangle
R = diag(neg) * Q; % R is orthonormal

if(abs(det(R)+1)<1e-4) % Ensures the determinant of R is positive by negating it if necessary.
    R = -R;
end

t = -R*center; % Translation vector: t = -Rc
