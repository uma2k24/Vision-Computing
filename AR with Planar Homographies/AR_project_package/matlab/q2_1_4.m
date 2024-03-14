%Q2.1.4
close all;
clear all;

cv_cover = imread('..\data\cv_cover.jpg');
cv_desk = imread('..\data\cv_desk.png');
hp_cover = imread('..\data\hp_cover.jpg');

% Random coordinate points from Nx2 matrices from cover and desk images
x1 = [169,48;229,64;259,95;260,294;220,306;142,320;221,320;127,321;133,324;279,386];
x2 = [363,213;429,217;437,233;432,345;413,362;330,374;414,373;315,375;321,377;486,430];

% x1_2 = [225,60;147,83;154,113;138,162;220,306;141,311;231,312;125,325;87,364;241,398];
% x2_2 = [388,220;430,211;350,242;506,32;413,362;330,367;350,242;401,411;411,255;442,443];

% % matchPics (BRIEF)
% [locs1, locs2] = matchPics(cv_cover, cv_desk);
% figure;
% showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, 'montage');
% title('Showing all matches');
% 
% % matchPics (SURF)
% [locs1, locs2] = matchPics_SURF(cv_cover, cv_desk);
% figure;
% showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, 'montage');
% title('Showing all matches');
% 
% % computeH
% [H2to1] = computeH(x1,x2)
% showMatchedFeatures(cv_cover, cv_desk, x1, x2, 'montage');
% 
% % computeH_norm
% [H2to1] = computeH_norm(x1,x2)
% showMatchedFeatures(cv_cover, cv_desk, x1, x2, 'montage');
% 
% computeH_ransac
[locs1, locs2] = matchPics(cv_cover, cv_desk);
[H,inliers] = computeH_ransac(locs1,locs2);
num_points = 4;
%num_points = 10;
%num_points = length(locs1);
point_pairs = zeros(num_points,2);
for i=1:num_points
    point_pairs(i,2) = randperm(size(cv_cover,1),1);
    point_pairs(i,1) = randperm(size(cv_cover,2),1);
end

point_pairs_2 = zeros(num_points,2);
for i=1:num_points
    tmp = [point_pairs(i,:),1]*H;
    point_pairs_2(i,1) = tmp(1)/tmp(3);
    point_pairs_2(i,2) = tmp(2)/tmp(3);
    
end

figure;
showMatchedFeatures(cv_cover, cv_desk, point_pairs, point_pairs_2, 'montage')

% Harry-Potterize
HP = imresize(hp_cover, size(cv_cover)); % Resize to that of cv_cover
warp_img = warpH(HP, H', size(cv_desk)); % Warp image

imshow(cv_desk + warp_img) % Display mask and cv_desk image
comp_img = compositeH(H, HP, cv_desk); % Create composite image
imshow(comp_img); % Display composite image