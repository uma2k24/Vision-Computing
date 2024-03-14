function [output] = pooling_layer_forward(input, layer)

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    
    
    output.height = h_out;
    output.width = w_out;
    output.channel = c;
    output.batch_size = batch_size;

    % Replace the following line with your implementation.
    % output.data = zeros([h_out, w_out, c, batch_size]);

    for pool_batch = 1:batch_size % for loop
        inbatch.data = input.data(:,pool_batch); % Indexes the batch columns in the input matrix
        inbatch.height = h_in; % Assign height, width, and channel
        inbatch.width = w_in;
        inbatch.channel = c;

        % Implementing the pooling function as described in the handout 
        im_to_col = im2col_conv(inbatch, layer, h_out, w_out); % im2col -> rearrange image blocks into columns
        square_kernel = reshape(im_to_col, k^2, c, h_out*w_out); % Reshape im2col array by k^2-by-c-by-h_out*w_out array
        max_kernel = max(square_kernel); % Find max value in each kernel
        max_pool = reshape(max_kernel, c, h_out*w_out); % Max pooling layer
        output_batch = reshape(max_pool', h_out, w_out, c); % ' = complex conjugate transpose
        output.data(:,pool_batch) = output_batch(:); % Output data
    end    

end

