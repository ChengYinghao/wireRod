function img_sobel_v = compute_sobel_v(img)
sobel_v_kernel = fspecial('sobel');
img_sobel_v = imfilter(img, sobel_v_kernel, 'symmetric');