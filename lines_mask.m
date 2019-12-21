function [line1, line2] = lines_mask(p1, p2, ps, thickness, expand)
% Ò»°ãÉèÖÃthickness=1, expand=3

dp = p2 - p1;
l = sqrt(sum(dp.^2));
n = dp / l;
m = n * [0 -1;1 0];

d1 = abs(sum( (ps-reshape(p1,1,1,2)) .* reshape(n,1,1,2), 3));
d2 = abs(sum( (ps-reshape(p2,1,1,2)) .* reshape(n,1,1,2), 3));
dm = abs(sum( (ps-reshape(p1,1,1,2)) .* reshape(m,1,1,2), 3));

line1 = thickness / 2 - d1 + expand;
line1(line1 <= 0.0) = 0.0;
line1(line1 >= expand) = expand;
line1 = line1 / expand;

line2 = thickness / 2 - d2 + expand;
line2(line2 <= 0.0) = 0.0;
line2(line2 >= expand) = expand;
line2 = line2 / expand;

cut = l - dm + expand;
cut(cut <= 0.0) = 0.0;
cut(cut >= expand) = expand;
cut = cut / expand;

line1 = line1.*cut;
line2 = line2.*cut;
