% “ª∞„…Ë÷√thickness=1, expand=3
function [line1, line2] = lines_mask(p1, p2, ps, thickness, expand)
dp = p2 - p1;
l = sqrt(sum(dp.^2));
n = dp / l;
m = n * [0 -1;1 0];
d1 = abs(sum((ps-p1).*n));
d2 = abs(sum((ps-p2).*n));
d1 = abs(sum((ps-p1).*m));

line1 = thickness / 2 - d1 + expand;
line1(line1 <= 0.0) = 0.0;
line1(line1 >= expand) = expand;
line1 = line1 / expand;
line2 = thickness / 2 - d2 + expand;
line2(line2 <= 0.0) = 0.0;
line2(line2 >= expand) = expand;
line2 = line2 / expand;

cut = 1 - d1 + expand;
cut(cut <= 0.0) = 0.0;
cut(cut >= expand) = expand;
cut = cut / expand;

line1 = line1.*cut;
line2 = line2.*cut;
end