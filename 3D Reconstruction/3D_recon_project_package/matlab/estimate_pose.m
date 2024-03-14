function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

%disp(size(x)); %2x10 double
%disp(size(X)); %3x10 double

n = size(x, 2);

% Linear system
A = zeros(2*n, 12); % 2D-3D point correspondences between the image plane and the object plane
for i = 1:n
    A((2*i-1), :) = [-(X(1,i)), -(X(2,i)), -(X(3,i)), -1, zeros(1,4), x(1,i)*X(1,i), x(1,i)*X(2,i), x(1,i)*X(3,i), x(1,i)];
    A((2*i), :) = [zeros(1,4), -(X(1,i)), -(X(2,i)), -(X(3,i)), -1, x(2,i)*X(1,i), x(2,i)*X(2,i), x(2,i)*X(3,i), x(2,i)];
end

% Solve the linear system using SVD
[~, ~, V] = svd(A);
p = V(:, end);
P = reshape(p, [4,3])'; % Reshapes the last column of V into a 3x4 matrix and transposes it to obtain the camera matrix P
