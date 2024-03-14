function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

% Conversion of images to grayscale to optimize matching
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

min_dist = 1e12; % Initialize minimum distance to a very large number.

pts_len = size(pts1, 1);
pts1 = [pts1 ones(pts_len, 1)];
pts1 = pts1';

line = F * pts1; % Calculate the epipolar lines using F
line = line / -line(2); % Calculation point of line 2

pts1 = round(pts1); % Convert points from float to integer since we need integers for indices

% Iterate over a small window of points around the epipolar line intersection with 
% the horizontal line passing through the first point, in the second image.
patch_1  = im1((pts1(2)-3):(pts1(2)+3), (pts1(1)-3):(pts1(1)+3), :);

X_1 = max(0, pts1(1)-10);
X_2 = min(size(im1, 2), pts1(1)+10);

pts2 = [pts1(1), line(1) * pts1(1) + line(3)];

% For each point in the window, calculate the distance to the patch centered at the point in the first image.
for i = X_1:X_2
    pt2 = round([i, line(1) * i + line(3), 1]);
    try
        patch_2 =  im2((pt2(2)-3):(pt2(2)+3), (pt2(1)-3):(pt2(1)+3));
        dist = sqrt(sum((patch_2 - patch_1).^ 2, 'all'));
        if dist < min_dist
            min_dist = dist;
            pts2 = [pt2(1), pt2(2)]; % Store the coordinates of the point with the smallest distance.
        end
    catch
    end
end