function [input_od] = relu_backward(output, input, layer)

% Replace the following line with your implementation.
% input_od = zeros(size(input.data));

in = input.data;

if in > 0 % Check if there is some input
    input_od = output.diff;
else
    input_od = 0.*output.diff; % .* -> Element wise multiplication
end

end
