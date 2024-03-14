function [output] = inner_product_forward(input, layer, param)

d = size(input.data, 1);
k = size(input.data, 2); % batch size
n = size(param.w, 2);

% Replace the following line with your implementation.
% output.data = zeros([n, k]);

% f(x) = Wx + b
% W = Weights -> 2D matrix m (neurons) * n (dimensionality of previous
% layer), b = biases (m*1 in size)
output.data = (ctranspose(param.w) * input.data) + ctranspose(param.b);

output.height = size(output.data);
output.width = size(output.data); % height = width -> square

output.channel = 100;
output.batch_size = 64;

end