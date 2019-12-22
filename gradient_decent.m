function [p1,p2,v1,v2,steps,D,dD] = gradient_decent(grad, p1, p2, v1, v2, varargin)
% 梯度下降调整锚点
% 可选参数默认值：
% max_steps=20, min_movement=0.001
% decent_rate=1.0, momentum=1.0, damping=0.3
% pan_rate=1000.0, rot_rate=5.0, spr_rate=2.0
% thickness=0.0, expand=8.0, ratio=1.0, 
% rot_restrict=1.0, spr_lower=nan, spr_upper=nan
%（建议取 spr_lower=img_size/25, spr_upper=img_size/5）

max_steps = 20;
min_movement = 0.001;

decent_rate = 1.0;
momentum = 1.0;
damping = 0.3;

thickness = 0.0;
expand = 8.0;
ratio = 1.0;

pan_rate = 1000.0;
rot_rate = 5.0;
spr_rate = 2.0;

for i=2:2:length(varargin)
    name = varargin{i-1};
    value = varargin{i};
    switch name
        case "max_steps"
            max_steps = value;
        case "min_movement"
            min_movement = value;
            
        case "decent_rate"
            decent_rate = value;
        case "momentum"
            momentum = value;
        case "damping"
            damping = value;
        
        case "thickness"
            thickness = value;
        case "expand"
            expand = value;
        case "ratio"
            ratio = value;
        
        case "pan_rate"
            pan_rate = value;
        case "rot_rate"
            rot_rate = value;
        case "spr_rate"
            spr_rate = value;
    end
end


[pxs, pys] = meshgrid(1:size(grad,2),1:size(grad,1));
ps(:,:,1) = pxs;
ps(:,:,2) = pys;

D = norm(p1-p2);
L = D*ratio;

pan_m = L*(thickness+expand)/pan_rate;
rot_m = L*L*(thickness+expand)/rot_rate;
spr_m = D/spr_rate;

for steps=1:max_steps
    [dv1, dv2] = gradient_onestep(grad,p1,p2,ps, ...
        pan_m,rot_m,spr_m, ...
        "thickness", thickness, ...
        "expand", expand,...
        "ratio", ratio, ...
        varargin{:});
    
    v1 = (v1+dv1*decent_rate/momentum)*(1-damping/momentum);
    v2 = (v2+dv2*decent_rate/momentum)*(1-damping/momentum);
    p1 = p1+v1;
    p2 = p2+v2;
    
    %figure, imshow(img), hold on
    %plot_ruler(p1,p2);
    
    last_D = D;
    D = norm(p1-p2);
    dD = abs(D-last_D);
    if dD <= D * min_movement
        break;
    end
    
    L = D * ratio;
    pan_m = L*(thickness+expand)/pan_rate;
    rot_m = L*L*(thickness+expand)/rot_rate;
    spr_m = D/spr_rate;
    
end