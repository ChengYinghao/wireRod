function [D,dD] = measure(img, varargin)
% ����ͼ�����߲ĵ�ֱ��
% ����ֵ����ֱ����ֱ���Ĳ�����ȷ����

edge_blur = 5;
grad_blur = 25;

for i=2:2:length(varargin)
    name = varargin{i-1};
    value = varargin{i};
    switch name
        case "edge_blur"
            edge_blur = value;
        case "grad_blur"
            grad_blur = value;
    end
end

img = im2double(img);
edges = compute_edges(img, edge_blur);
grad = compute_grad(edges,grad_blur);
[p1, p2] = initial_points(edges, varargin{:});

v1 = 0.0;
v2 = 0.0;
[~,~,~,~,~,D,dD] = gradient_decent(grad,p1,p2,v1,v2, varargin{:});
