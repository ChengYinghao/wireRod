function grad = compute_grad(edges, blur)
% 根据边缘图计算梯度，shape为(w,h,2) 
% 最后一个维度分别为x和y方向的梯度

edges = compute_blur(edges, blur);
grad(:,:,1)=compute_sobel_h(edges);
grad(:,:,2)=compute_sobel_v(edges);
grad = -grad;