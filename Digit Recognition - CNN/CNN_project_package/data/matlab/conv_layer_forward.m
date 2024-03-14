function [output] = conv_layer_forward(input, layer, param)
% Conv layer forward
% input: struct with input data
% layer: convolution layer struct
% param: weights for the convolution layer

% output: 

h_in = input.height;
w_in = input.width;
c = input.channel;
batch_size = input.batch_size;
k = layer.k;
pad = layer.pad;
stride = layer.stride;
num = layer.num;
% resolve output shape
h_out = (h_in + 2*pad - k) / stride + 1;
w_out = (w_in + 2*pad - k) / stride + 1;

assert(h_out == floor(h_out), 'h_out is not integer')
assert(w_out == floor(w_out), 'w_out is not integer')
input_n.height = h_in;
input_n.width = w_in;
input_n.channel = c;

%% Fill in the code
% Iterate over the each image in the batch, compute response,
% Fill in the output datastructure with data, and the shape.

field_grp = 1; % Field group set to 1

for n = 1:batch_size
    input_n.data = input.data(:,n); % Input data
    col = im2col_conv(input_n, layer, h_out, w_out); % Image to color conversion
    col = reshape(col, (k^2)*c, h_out*w_out); % reshape -> reshape col array into (k^2)*c x h_out*w_out array
    
    for g = 1:field_grp
        col_g = col((g-1)*(k^2)*c/field_grp + 1:g*(k^2)*c/field_grp, :);
        weight = param.w(:, (g-1)*num/field_grp + 1:g*num/field_grp); % Weight
        b = param.b(:, (g-1)*num/field_grp + 1:g*num/field_grp); % bias
        temp(:, (g-1)*num/field_grp + 1:g*num/field_grp) = bsxfun(@plus, col_g' * weight, b); % Temporary output
        % @plus -> function handle to funtion "plus"
    end

    output.data(:, n) = temp(:); % Make the n'th column of output data array a single column vector of the temp output
    clear temp; % Clear temporary output

end

output.height = h_out; % Assign values
output.width = w_out;

output.channel = num;
output.batch_size = batch_size;

end