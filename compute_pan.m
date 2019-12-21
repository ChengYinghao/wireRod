function pan = compute_pan(grad, mask, pan_m)
pan = sum(sum(grad.*mask,1),2);
pan = reshape(pan,1,2);
pan = pan / pan_m;
end