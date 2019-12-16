function img_sobel_h = compute_sobel_h(img)
sobel_h_kernel = fspecial('sobel')';
img_sobel_h = imfilter(img, sobel_h_kernel, 'symmetric');