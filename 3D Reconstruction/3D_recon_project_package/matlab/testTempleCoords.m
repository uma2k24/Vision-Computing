% A test script using templeCoords.mat

% 1) Read the images and load someCorresp.mat

im1 = imread('..\data\im1.png');
im2 = imread('..\data\im2.png');

load('..\data\someCorresp.mat');

fprintf("M value: %d", M);
fprintf("\n\n");


% 2) Run eightpoint to compute fundamental matrix F

F = eightpoint(pts1, pts2, M);


% 3) Load points in im1 in templeCoords.mat and run epipolarCorrespondences.m to get corresponding points in image

load('..\data\templeCoords.mat');

pts2 = zeros(size(pts1));
for i = 1:size(pts2, 1)
    pts2(i,:) = epipolarCorrespondence(im1, im2, F, pts1(i, :));
end


% 4) Load intrinsics.mat and compute essential matrix E

load('..\data\intrinsics.mat');

E = essentialMatrix(F, K1, K2);
fprintf("F:\n")
disp(F);
fprintf("\n");
fprintf("E:\n")
disp(E);


% 5) Compute projection matrix P1 and compute four candidates for P2 using camera2.m

P1 = K1 * [eye(3), zeros(3,1)];


% 6) Run triangulate function using the four sets of camera matrix candidates, the points from templeCoords.mat and their computed correspondences


% 7) Figure out the correct P2 and the corresponding 3D points

P2_can = camera2(E); % Since we have size (3,4,4) -> 4 candidates
min_dist = 1e12;
min_dist_pts1 = 1e12;
min_dist_pts2 = 1e12;

for i = 1:4
    if det(P2_can(1:3, 1:3, i)) ~= 1 % ~= -> determine inequality
        P2_can(:,:,i) = K2 * P2_can(:,:,i);
        pts_3D_can = triangulate(P1, pts1, P2_can(:, :, i), pts2);
        
        X1 = P1 * (pts_3D_can');
        X2 = P2_can(:,:,i) * (pts_3D_can');
        
        X1 = X1./X1(3,:);
        X2 = X2./X2(3,:);

        X1 = X1';
        X2 = X2';

        if sum((pts_3D_can(:,3) > 0), 'all') == size(pts_3D_can,1)
            dist_pts1 = norm(pts1 - X1(:,1:2)) / size(pts_3D_can,1);
            dist_pts2 = norm(pts2 - X2(:,1:2)) / size(pts_3D_can,1);
            dist = dist_pts1 + dist_pts2;
            if dist < min_dist
                min_dist = dist;
                min_dist_pts1 = dist_pts1;
                min_dist_pts2 = dist_pts2;
                pts3d = pts_3D_can;
                P2 = P2_can(:,:,i);
            end
        end
    end
end

fprintf("Reprojection error pts1: %f\n", min_dist_pts1);
fprintf("Reprojection error pts2: %f\n", min_dist_pts2);

% 8) Plot the point correspondences

plot3(pts3d(:, 1), pts3d(:, 2), pts3d(:, 3), 'b.');
axis equal;
rotate3d on;

% 9) Save extrinsic parameters for dense reconstruction

R1 = K1 \ P1(1:3, 1:3);
t1 = K1 \ P1(:, 4);

R2 = K2 \ P2(1:3, 1:3);
t2 = K2 \ P2(:, 4);

save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
