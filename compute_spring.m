% upper和lower一般设为NaN, rebound一般设为0.0
function [s1, s2] = compute_spring(p1, p2, spr_m, lower, upper, rebound)
if isnan(upper)
    upper = lower;
end

l = sqrt(sum((p1-p2).^2));
if ~isnan(lower)
    dl_lower = lower - l;
    if dl_lower > 0
        dp1 = (p1 - p2) * (dl_lower + rebound);
        dp2 = -dp1;
        s1 = dp1 / spr_m; s2 = dp2 / spr_m;
    end
    
elseif ~isnan(upper)
    dl_upper = l - upper;
    if dl_upper > 0
        dp1 = (p2 - p1) * (dl_upper + rebound);
        dp2 = -dp1;
        s1 = dp1 / spr_m; s2 = dp2 / spr_m; 
    end
else
    s1 = [0.0 0.0]; s2 = [0.0 0.0];
end