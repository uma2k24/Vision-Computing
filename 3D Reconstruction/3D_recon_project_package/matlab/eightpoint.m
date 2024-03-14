function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

pts_len = size(pts1, 1);

%disp(pts1);

pts1 = [pts1 ones(pts_len, 1)]; % 3rd element set to 1 -> append 1 to each element
pts2 = [pts2 ones(pts_len, 1)];

T = [1/M,0,0;
    0,1/M,0;
    0,0,1;];

pts1 = pts1 * T';
pts2 = pts2 * T';

% Eight-point algo
A = zeros(pts_len, 9); % Matrix A with the product of each pair of corresponding points from pts1 and pts2
for i = 1:3
    for j = 1:3
        column = ((i-1)*3)+j;
        A(:, column) = pts1(:, i, :).*pts2(:, j, :);
    end
end

[~,~,V] = svd(A); % Single-value decomposition
F = reshape(V(:, end), [3,3]);

[U,D,V] = svd(F);
D(end, end) = 0;
F = U * D * V';

F = refineF(F, pts1, pts2); % Refine using local minimization

F = T' * F * T;
