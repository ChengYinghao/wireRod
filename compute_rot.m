function [dp1, dp2] = compute_rot(p1, p2, ps, grad, mask, rot_m, rot_restrict)
% 计算单步旋转产生的变化
% rot_restrict是旋转角度的最大值（不能一下子转太多），单位为角度（360度的那个）

pc = (p1 + p2) / 2;
pd = ps - reshape(pc,1,1,2);

rot = grad(:,:,1).*pd(:,:,2)-grad(:,:,2).*pd(:,:,1);
rot = sum(sum(rot .* mask));

rot = rot / rot_m;
rot_restrict = pi / 180 * rot_restrict;
if rot > rot_restrict
    rot = rot_restrict;
elseif rot < -rot_restrict
    rot = -rot_restrict;
end
rm = [cos(rot),-sin(rot);sin(rot),cos(rot)];

dp1 = p1 - pc;
dp2 = p2 - pc;
dp1 = dp1 * rm - dp1;
dp2 = dp2 * rm - dp2;
