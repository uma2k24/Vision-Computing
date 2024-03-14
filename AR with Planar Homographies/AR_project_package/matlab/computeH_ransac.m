function [ bestH2to1, inliers] = computeH_ransac(locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

num_iterations = 100000; %number of iterations, higher value = higher accuracy
dist_Thresh = 1; %threshold distance, lower number = greater precision on transformation

max_inlier_count = 0;
inliers = zeros(1,size(locs2,1));
num_of_points = 4;

for k=1:num_iterations
    inlier_count = 0;
    num_inliers = zeros(1,size(locs2,1));

    samp_1 = zeros(num_of_points,2);
    samp_2 = zeros(num_of_points,2);

    % Randomly sample 4 points from the input point sets
    for i=1:num_of_points
        rand_points = randperm(size(locs1,1),1);
        samp_1(i,1) = locs1(rand_points, 1);
        samp_1(i,2) = locs1(rand_points, 2);
        samp_2(i,1) = locs2(rand_points, 1);
        samp_2(i,2) = locs2(rand_points, 2);
    end

    % Compute homography with the sampled points
    H = computeH_norm(samp_1,samp_2);

    calc_locs2 = zeros(size(locs1,1),2);
    for i=1:size(locs1,1)
        tmp = [locs1(i,:),1]*H;
        calc_locs2(i,1) = tmp(1)/tmp(3);
        calc_locs2(i,2) = tmp(2)/tmp(3);
    end

    for i=1:size(locs2,1)
        dist_x = calc_locs2(i,1) - locs2(i,1);
        dist_y = calc_locs2(i,2) - locs2(i,2);
        dist = sqrt(dist_x^2 + dist_y^2);
        
        % Count the inliers depending on threshold distance
        if dist < dist_Thresh
            inlier_count = inlier_count + 1;
            num_inliers(i) = 1;
        end
    end
    
    % Update homography and inliers if more inliers are detected
    if inlier_count > max_inlier_count
        max_inlier_count = inlier_count;
        inliers = num_inliers;
        bestH2to1 = H;
    end
    
end