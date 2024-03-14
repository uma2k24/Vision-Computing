% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
cover_img = imread("..\data\cv_cover.jpg");

%% Compute the features and descriptors

% Initialize the histograms
BRIEF_histogram = zeros(1, 36);
SURF_histogram = zeros(1, 36);

for i = 0:35
    %% Rotate image

    cover_img_rotate = imrotate(cover_img, (i+1)*10);
    
    %% Compute features and descriptors

    [BRIEF_loc1, BRIEF_loc2] = matchPics(cover_img, cover_img_rotate);
    [SURF_loc1, SURF_loc2] = matchPics_SURF(cover_img, cover_img_rotate);
    
    %% Match features
    if i == 4 || i == 9 || i == 12 %capture a figure at 3 different angles
        figure;
        showMatchedFeatures(cover_img, cover_img_rotate, BRIEF_loc1, BRIEF_loc2, 'montage')
        figure;
        showMatchedFeatures(cover_img, cover_img_rotate, SURF_loc1, SURF_loc2, 'montage')
    end
    
    %% Update histogram

    SURF_histogram(i+1) = length(SURF_loc1);
    BRIEF_histogram(i+1) = length(BRIEF_loc1);
end

%% Display histogram

% Dimensions:

BRIEF_dim = (10:10:360);
SURF_dim = (10:10:360);

figure
% Plot BRIEF
subplot(1,2,1)
bar(BRIEF_dim, BRIEF_histogram)
xlabel('Degrees of Rotation')
ylabel('# of Matches')
title('BRIEF Histogram')

% Plot SURF
subplot(1,2,2)
bar(SURF_dim, SURF_histogram)
xlabel('Degrees of Rotation')
ylabel('# of Matches')
title('SURF Histogram')