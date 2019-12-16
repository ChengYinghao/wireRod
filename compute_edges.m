% 传入RGB三通道图像，输出sobel滤波处理后的矩阵
function edges = compute_edges(img, gau_size, sigma)
GX= [1,2,1;0,0,0;-1,-2,1];
GY = GX';
gau = fspecial('', gau_size, sigma);
components = [];
for i = 1:size(img)
    img_i = img(:,:,i);
    blur = imfilter(img_i, gau, 'replicate');
    components = [components;imfilter(img_i, GX, 'replicate')];
    components = [components;imfilter(img_i, GY, 'replicate')];
end
edges = sqrt(sum(power(components, 2)));
    


