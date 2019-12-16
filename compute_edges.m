function edges = compute_edges(img, sigma)
% 提取（多通道）图像的边缘（通道合并使用平方和）

truncate = 4.0;
gaussian_kernel_size = 2*sigma*truncate+1;
gaussian_kernel = fspecial('gaussian', gaussian_kernel_size, sigma);

sobel_h_kernel = fspecial('sobel');
sobel_v_kernel = sobel_h_kernel';

components = [];
for i = 1:size(img)
    chan = img(:,:,i);
    chan_blur = imfilter(chan, gaussian_kernel, 'replicate');
    components(end+1) = imfilter(chan_blur, sobel_h_kernel, 'replicate');
    components(end+1) = imfilter(chan_blur, sobel_v_kernel, 'replicate');
end

edges = sqrt(sum(power(components, 2)));
