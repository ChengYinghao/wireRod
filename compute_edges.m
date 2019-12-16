function edges = compute_edges(img, sigma)
% 提取（多通道）图像的边缘（通道合并使用平方和）

img = compute_blur(img,sigma);

sobel_h_kernel = [1,2,1;0,0,0;-1,-2,-1]; %fspecial('sobel');
sobel_v_kernel = sobel_h_kernel';

components = zeros(0,0,0);
for i = 1:size(img,3)
    chan = img(:,:,i);
    components(:,:,end+1) = compute_sobel_h(chan);
    components(:,:,end+1) = compute_sobel_v(chan);
end
edges = sum(components.^2,3).^(1/2);
%figure, imshow(edges);
