function grad = compute_grad(edges, blur)
% 根据边缘图计算梯度，shape为(w,h,2) 
% 最后一个维度分别为x和y方向的梯度

edges_blur = gaussian(edges, blur);
grad(:,:,1)=sobel_v(edges_blur);
grad(:,:,2)=sobel_h(edges_blur);
