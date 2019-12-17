function [theta1, rho1, theta2, rho2] = find_parallel(edges, bin_threshold)
% 利用霍夫变换寻找平行线
% bin_threshold=0.03
% hough_blur=1

edges_bin = edges > bin_threshold;
[h, thetas, rhos] = hough(edges_bin);

peaks = houghpeaks(h,2);
rho1=rhos(peaks(1,1));
theta1=thetas(peaks(1,2))/180*pi;
rho2=rhos(peaks(2,1));
theta2=thetas(peaks(2,2))/180*pi;