function [H2to1] = computeH_norm(x1, x2)

% x1 = [252,39;292,42;194,45;214,47;169,48;206,48;220,48;195,60;225,60;287,61];
% x2 = [430,328;430,328;437,233;506,32;363,213;374,213;437,233;374,215;388,220;412,215];

%% Compute centroids of the points
centroid1 = round(mean(x1));
centroid2 = round(mean(x2));

%% Shift the origin of the points to the centroid

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

%% similarity transform 1
T1 = [sqrt(2), 0, sqrt(2)*centroid1(1);
      0, sqrt(2), sqrt(2)*centroid1(2);
      0, 0, 1];

%% similarity transform 2
T2 = [sqrt(2), 0, sqrt(2)*centroid2(1);
      0, sqrt(2), sqrt(2)*centroid2(2);
      0, 0, 1];

%% Compute Homography
T_x1 = zeros(size(x1,1), 2);
T_x2 = zeros(size(x2,1), 2);

for i = 1:size(x1,1)
    temp_1 = [x1(i,:),1]*T1;
    temp_2 = [x2(i,:),1]*T2;

    T_x1(i,1) = temp_1(1)/temp_1(3);
    T_x1(i,2) = temp_1(2)/temp_1(3);

    T_x2(i,1) = temp_2(1)/temp_2(3);
    T_x2(i,2) = temp_2(2)/temp_2(3);
end

%% Denormalization

H_norm = computeH(T_x1,T_x2);
H2to1 = (T1*H_norm*inv(T2));