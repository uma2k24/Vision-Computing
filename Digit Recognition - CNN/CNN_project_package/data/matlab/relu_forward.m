function [output] = relu_forward(input)
output.height = input.height;
output.width = input.width;
output.channel = input.channel;
output.batch_size = input.batch_size;

% Replace the following line with your implementation.
% output.data = zeros(size(input.data));

% ReLU -> Rectified Linear Unit

in = input.data;

% f(x) = max(x, 0)
output.data = max(0,in);

end
