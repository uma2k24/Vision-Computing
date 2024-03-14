function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
% param_grad.b = zeros(size(param.b));
% param_grad.w = zeros(size(param.w));

% output.diff = delta(l)/delta(h_i)
param_grad.b = sum(output.diff,2)'; % delta(l)/delta(b)
param_grad.w = (output.diff*(input.data)')'; % delta(l)/delta(w)
input_od = (param.w * output.diff); % delta(l)/delta(h_i-1)

end
