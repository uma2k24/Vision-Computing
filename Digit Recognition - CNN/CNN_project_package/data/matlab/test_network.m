%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

% load the trained weights
load lenet.mat

%% Testing the network
% Modify the code to get the confusion matrix

numbers = 10;
predict = zeros(numbers, size(ytest,2));

for i=1:100:size(xtest, 2)
    [output, P] = convnet_forward(params, layers, xtest(:, i:i+99));
    predict(:, i:i+99) = predict(:, i:i+99) + P;
end

[val, ind] = max(predict);
conf = confusionchart(ind-1, ytest-1);