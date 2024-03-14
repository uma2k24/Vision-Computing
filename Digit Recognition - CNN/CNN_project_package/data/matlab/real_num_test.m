clear
clc

layers = get_lenet();
layers{1}.batch_size = 1;

load lenet.mat

%% Network Test

numbers = 10;
realnumsample = [1,2,3,4,5];
predictor = zeros(numbers, size(realnumsample,2));

path = "../real_numbers/"; % File path

for i = 1:size(realnumsample,2) % for loop to read image files in folder
    in_file = path + "real_num_" + i + ".jpg"; % Acquire file name
    in = double(rgb2gray(imread(in_file))); % Convert from rgb to grayscale
    in = imresize(in,[28,28]); % Change dimensions to 28x28

    % in = in(:); % Convert matrix to a vector -> old method

    in = im2col(in, [28,28]); % Rearrange image blocks of size 28x28 into columns and return the concatenations in the "in" matrix
    in = in./max(in); % Right array division; divides each element of the "in" array by the corresponding max value of in
    [output, P] = convnet_forward(params, layers, in); % Call upon convnet_forward function
    predictor(:, i) = P; % Probabilities
end

% for i = 1:5:size(realnumsample,1)
%     [output, P] = convnet_forward(params, layers, input(:, i));
%     predictor(:, i) = predictor(:, i) + P;
% end

[value,index] = max(predictor);
conf = confusionchart(realnumsample, index-1); % Create a confusion matrix

disp(realnumsample); % Display the real numbers and the predicted output
disp (index-1);

% "D:\Matlab 2022\CMPT412\project1_package\real_numbers\real_num_" + i + ".jpg"; % Acquire file name