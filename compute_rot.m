function [dp1, dp2] = compute_rot(p1, p2, ps, grad, mask, rot_m, max_rot)
% max_rotÒ»°ãÈ¡1

pc = (p1 + p2) / 2;
pd = ps - reshape(pc,1,1,2);

rot = grad(:,:,1).*pd(:,:,2)-grad(:,:,2).*pd(:,:,1);
rot = sum(sum(rot .* mask));

rot = rot / rot_m;
max_rot = pi / 180 * max_rot;
if rot > max_rot
    rot = max_rot;
elseif rot < -max_rot
    rot = -max_rot;
end
rm = [cos(rot),-sin(rot);sin(rot),cos(rot)];

dp1 = p1 - pc;
dp2 = p2 - pc;
dp1 = dp1 * rm - dp1;
dp2 = dp2 * rm - dp2;
