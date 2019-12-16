function pan = compute_pan(grad, mask, pan_m)
pan = sum(sum(grad.*mask));
pan = pan / pan_m;
end