function blur = compute_blur(img,sigma)

truncate = 4.0;
blur_kernel_size = 2*sigma*truncate+1;
blur_kernel = fspecial('gaussian', blur_kernel_size, sigma);

blur = imfilter(img,blur_kernel, 'symmetric');
%figure, imshow(blur);