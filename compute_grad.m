function grad = compute_grad(edges, blur)
% ���ݱ�Եͼ�����ݶȣ�shapeΪ(w,h,2) 
% ���һ��ά�ȷֱ�Ϊx��y������ݶ�

edges = compute_blur(edges, blur);
grad(:,:,1)=compute_sobel_h(edges);
grad(:,:,2)=compute_sobel_v(edges);
grad = -grad;