function plot_line(width, height, theta, rho)
if mod((theta + np.pi / 4), pi) <= pi / 2
    xs = [0, width];
    ys = (rho - xs * cos(theta)) / sin(theta);
else
    ys = [0, height];
    xs = (rho - ys * sin(theta)) / cos(theta);
end
plot(xs, height - ys, 'b')
end