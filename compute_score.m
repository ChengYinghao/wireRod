function score = compute_score(mask, edges)
score = mean(mean(mask.*edges));
end