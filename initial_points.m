function [p1, p2] = initial_points(theta1, rho1, theta2, rho2, width, height)
theta = (theta1 + theta2) / 2;
rho = (rho1 + rho2) / 2;

sin_theta = sin(theta);
cos_theta = cos(theta);

xc = width / 2;
yc = height / 2;

xpc = xc * sin_theta * sin_theta + cos_theta * (rho - yc * sin_theta);
ypc = yc * cos_theta * cos_theta + sin_theta * (rho - xc * cos_theta);

pc = [xpc, ypc];
n = [cos_theta, sin_theta];
d = (rho1 - rho2) / 2;
p1 = pc + n * d;
p2 = pc - n * d;
end

