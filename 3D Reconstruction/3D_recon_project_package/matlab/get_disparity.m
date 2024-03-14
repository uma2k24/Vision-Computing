function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

% windowSize: size of the window used to compute the pixel disparity

% window_mask: to be used as a convolution kernel to compute the disparity map
window_mask = ones(windowSize, windowSize); 

dispM = zeros(size(im1));
min_disp = ones(size(im1)) * inf;

im1 = double(im1); %Convert images to doubles
im2 = double(im2);

% Loops over all possible disparities between 0 and maxDisp. 
% In each iteration, im2 is translated horizontally by the current disparity disp using the imtranslate() function. 
% The resulting translated image is then subtracted from im1, and the squared difference is convolved with the window_mask kernel using the conv2() function. 
% The resulting disparity map dispM_curr is compared with the minimum disparity map min_disp. 
% Pixels in dispM with a dispM_curr smaller than the current min_disp are updated to the current disparity disp, and the min_disp map is updated to the current dispM_curr.
for disp = 0:maxDisp
    im2_translate = imtranslate(im2, [disp,0], 'FillValues', 255);
    dispM_curr = conv2((im1-im2_translate).^2, window_mask, 'same');
    dispM(dispM_curr < min_disp) = disp;
    min_disp = min(min_disp, dispM_curr);
end