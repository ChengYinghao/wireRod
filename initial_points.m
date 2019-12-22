function [p1, p2] = initial_points(edges, varargin)
% 计算初始位置
% 默认参数：
% shrink = floor(min([width, height]/64));

shrinking = nan;
bin_threshold = 0.03;
for i=2:2:length(varargin)
    name = varargin{i-1};
    value = varargin{i};
    switch name
        case "shrinking"
            shrinking = value;
        case "bin_threshold"
            bin_threshold = value;
    end
end

[height, width] = size(edges);

if isnan(shrinking)
    shrinking = floor(min([width, height]/64));
end
edges_shrinked = edges(1:shrinking:end,1:shrinking:end);
%figure; imshow(edges_shrinked,"InitialMagnification",shrinking*100), hold on

[theta1, rho1_shrinked, theta2, rho2_shrinked] = find_parallel(edges_shrinked,bin_threshold);

%img_shrinked = img(1:shrink_scale:end,1:shrink_scale:end,:);
%figure; imshow(img_shrinked,"InitialMagnification",shrinking*100), hold on
%plot_line(width,height,theta1,rho1_shrinked);
%plot_line(width,height,theta2,rho2_shrinked);

rho1 = rho1_shrinked * shrinking;
rho2 = rho2_shrinked * shrinking;

theta = (theta1 + theta2) / 2;
rho = (rho1 + rho2) / 2;

sin_theta = sin(theta);
cos_theta = cos(theta);

xc = width / 2;
yc = height / 2;
xpc = xc * sin_theta * sin_theta + cos_theta * (rho - yc * sin_theta);
ypc = yc * cos_theta * cos_theta + sin_theta * (rho - xc * cos_theta);

pc = [xpc, ypc];
n = [cos_theta, sin_theta];
d = (rho1 - rho2) / 2;
p1 = pc + n * d;
p2 = pc - n * d;
