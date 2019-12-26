function [D,dD] = measure(img, varargin)
% 测量图像中线材的直径
% 返回值包括直径和直径的测量不确定度
% 可选参数默认值：
% edge_blur=5, grad_blur=25
% max_steps=20, min_movement=0.001
% decent_rate=1.0, momentum=1.0, damping=0.3
% pan_rate=1000.0, rot_rate=5.0, spr_rate=2.0
% thickness=0.0, expand=8.0, ratio=1.0, 
% rot_restrict=1.0, spr_lower=img_size/25, spr_upper=img_size/5

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


img_size = norm([size(img,1), size(img,2)]);
spr_lower=img_size/25;
spr_upper=img_size/5;

v1 = 0.0;
v2 = 0.0;
[~,~,~,~,~,D,dD] = gradient_decent(grad,p1,p2,v1,v2, ...
    "spr_lower",spr_lower, ...
    "spr_upper",spr_upper, ...
    varargin{:});
