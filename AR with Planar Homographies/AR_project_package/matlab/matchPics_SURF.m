function [locs1, locs2] = matchPics_SURF(I1, I2)
%MATCHPICS Extract features, obtain their descriptors, and match them!
    %I1 = imread("..\data\cv_cover.jpg");
    %I2 = imread("..\data\cv_desk.png");
    thresh = 10.0; %threshold
    r = 0.9; %ratio
    im1 = I1; %load images
    im2 = I2;

%% Convert images to grayscale, if necessary

    if(ndims(im1) == 3)
        im1 = rgb2gray(im1);
    end

    if(ndims(im2) == 3)
        im2 = rgb2gray(im2);
    end

%% Detect features in both images

    corners1 = detectSURFFeatures(im1);
    corners2 = detectSURFFeatures(im2);

%% Obtain descriptors for the computed feature locations
    [desc1, l1] = extractFeatures(im1, corners1.Location);
    [desc2, l2] = extractFeatures(im2, corners2.Location);

%% Match features using the descriptors

    indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', thresh, 'MaxRatio', r);
  
    locs1 = l1(indexPairs(:,1),:);
    locs2 = l2(indexPairs(:,2),:);

    %showMatchedFeatures(im1, im2, locs1, locs2, 'montage')
end