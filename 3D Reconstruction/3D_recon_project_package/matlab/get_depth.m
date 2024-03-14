function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).

% Computes the 3D coordinates of the corresponding points in 
% camera coordinates using the camera matrices, rotations, and translations
c1 = -inv(K1*R1)*(K1*t1);
c2 = -inv(K2*R2)*(K2*t2);

% Computes the baseline and focal length 
% based on the camera matrices and the translation vectors.
b = norm(c1-c2); %baseline
f = K1(1,1); %focal length

% Calculates the depth map by dividing the baseline times the focal length by the disparity values. 
% It sets the depth to zero wherever the disparity is zero.
depthM = b*f./dispM;
depthM(dispM == 0) = 0;
