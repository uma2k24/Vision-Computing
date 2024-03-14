layers = get_lenet();
load lenet.mat
% load data
% Change the following value to true to load the entire dataset.
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);
xtrain = [xtrain, xvalidate];
ytrain = [ytrain, yvalidate];
m_train = size(xtrain, 2);
batch_size = 64;
 
 
layers{1}.batch_size = 1;
img = xtest(:, 1);
img = reshape(img, 28, 28);
imshow(img')

figure; % Display figure
pause(3) % Pause for 3 seconds
 
%[cp, ~, output] = conv_net_output(params, layers, xtest(:, 1), ytest(:, 1));
output = convnet_forward(params, layers, xtest(:, 1));
output_1 = reshape(output{1}.data, 28, 28);
% Fill in your code here to plot the features.

output_2 = output{2}.data; % Second layer - CONV
a = 1;

for i = 1:576:11520 % 576 = 24^2 (reshaped image size), 11520 = (24^2) * 20 (total number of images/features to visualize)
    num_image = output_2(i:i+575);
    num_image = reshape(num_image, 24, 24); % Reshape image to 24x24 size
    num_image = imresize(num_image, 5); % Resize image by a scale factor of 5
    num_image = imrotate(num_image, -90); % Rotate image 90 degrees clockwise
    num_image = flip(num_image, 2); % Flip the image by reversing the order of the pixels in both dimensions
    subplot(4,5,a),imshow(num_image); % Display all 20 images from each layer in a 4x5 format
    a = a+1;
end

sgtitle('CONV Layer')

pause(2)
figure; % Display in a separate figure and not overwrite when code for third layer is run


output_3 = output{3}.data; % Third layer - ReLU
a = 1;

for i = 1:576:11520
    num_image = output_3(i:i+575);
    num_image = reshape(num_image, 24, 24);
    num_image = imrotate(num_image, -90);
    num_image = imresize(num_image, 5);
    num_image = flip(num_image, 2);
    subplot(4,5,a),imshow(num_image);
    a = a+1;
end

sgtitle('ReLU Layer')

