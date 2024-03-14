function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points

%x1 = [252,39;292,42;194,45;214,47;169,48;206,48;220,48;195,60;225,60;287,61];
%x2 = [430,328;430,328;437,233;506,32;363,213;374,213;437,233;374,215;388,220;412,215];

N = size(x1,1);

x_1 = x1(:,1);
y_1 = x1(:,2);
x_2 = x2(:,1);
y_2 = x2(:,2);

zeros_row = zeros(3, N);

xy_rows = -[x_1.'; y_1.'; ones(1,N)];

A = zeros(2*N, 9);
for i=1:N
    A(2*i-1,:) = [xy_rows(:,i).', zeros_row(:,i).', x_2(i)*x_1(i), x_2(i)*y_1(i), x_2(i)];
    A(2*i,:) = [zeros_row(:,i).', xy_rows(:,i).', y_2(i)*x_1(i), y_2(i)*y_1(i), y_2(i)];
end

if N == 4
    h = null(A);
end

[~,~,V] = svd(A); %singular value decomposition
h = V(:, 9);

H2to1 = reshape(h,3,3);