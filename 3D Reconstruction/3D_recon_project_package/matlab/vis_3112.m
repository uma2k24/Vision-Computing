% Visualization of 3.1.1 and 3.1.2

% Load the data
load('..\data\someCorresp.mat');

% Read the images
img1 = imread('..\data\im1.png');
img2 = imread('..\data\im2.png');

M = max(size(img1,1), size(img1,2)); %Ensures both images are of same size
fprintf("M value: %d.\n", M); %Print value of M

% Call eightpoint function
F = eightpoint(pts1, pts2, M);
disp("F: ");
disp(F);

% % Visualize epipolar lines (3.1.1)
% displayEpipolarF(img1, img2, F);

% Visualize epipolar match (3.1.2)
epipolarMatchGUI(img1, img2, F);