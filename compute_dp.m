function [dp1, dp2] = compute_dp(p1, p2, ps, grad, pan_m, rot_m, spr_m, thickness, expand, dis_range, rebound)
% “ª∞„»°thickness=1, expand=3, dis_range=(50, 150), rebound=10

[mask1, mask2] = lines_mask(p1, p2, ps, thickness, expand);
mask_all = mask1 + mask2;

dp1 = zeros(1,2);
dp2 = zeros(1,2);

dp1_pan = compute_pan(grad, mask1, pan_m);
dp2_pan = compute_pan(grad, mask2, pan_m);
dp1 = dp1 + dp1_pan;
dp2 = dp2 + dp2_pan;

[dp1_rot, dp2_rot] = compute_rot(p1, p2, ps, grad, mask_all, rot_m, 1);
dp1 = dp1 + dp1_rot;
dp2 = dp2 + dp2_rot;

[dp1_spr, dp2_spr] = compute_spring(p1, p2, spr_m, dis_range(1), dis_range(2), rebound);
dp1 = dp1 + dp1_spr;
dp2 = dp2 + dp2_spr;