function [dp1, dp2] = gradient_onestep(grad, p1, p2, ps, pan_m, rot_m, spr_m, varargin)
% 计算梯度下降的单步变化
% 可选参数默认值：
% thickness=0.0, expand=8.0, ratio=1.0, 
% rot_restrict=1.0, spr_lower=nan, spr_upper=nan
%（建议取 spr_lower=img_size/25, spr_upper=img_size/5）

thickness = 0.0;
expand = 8.0;
ratio = 1.0;

rot_restrict = 1.0;
spr_lower = nan;
spr_upper = nan;

for i=2:2:length(varargin)
    name = varargin{i-1};
    value = varargin{i};
    switch name
        case "thickness"
            thickness = value;
        case "expand"
            expand = value;
        case "ratio"
            ratio = value;
            
        case "rot_restrict"
            rot_restrict = value;
        case "spr_lower"
            spr_lower = value;
        case "spr_upper"
            spr_upper = value;
    end
end


[mask1, mask2] = lines_mask(p1, p2, ps, thickness, expand, ratio);
mask_all = mask1 + mask2;

dp1 = zeros(1,2);
dp2 = zeros(1,2);

dp1_pan = compute_pan(grad, mask1, pan_m);
dp2_pan = compute_pan(grad, mask2, pan_m);
dp1 = dp1 + dp1_pan;
dp2 = dp2 + dp2_pan;

[dp1_rot, dp2_rot] = compute_rot(p1, p2, ps, grad, mask_all, rot_m, rot_restrict);
dp1 = dp1 + dp1_rot;
dp2 = dp2 + dp2_rot;

[dp1_spr, dp2_spr] = compute_spring(p1, p2, spr_m, spr_lower, spr_upper, 0.0);
dp1 = dp1 + dp1_spr;
dp2 = dp2 + dp2_spr;
