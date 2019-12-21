function edges = compute_edges(img, sigma)
% ��ȡ����ͨ����ͼ��ı�Ե��ͨ���ϲ�ʹ��ƽ���ͣ�

img = compute_blur(img,sigma);

components = zeros(size(img,1),size(img,2),size(img,3)*2);
for i = 1:size(img,3)
    chan = img(:,:,i);
    components(:,:,i*2-1) = compute_sobel_h(chan);
    components(:,:,i*2) = compute_sobel_v(chan);
end
edges = sum(components.^2,3).^(1/2);

%figure, imshow(edges);
