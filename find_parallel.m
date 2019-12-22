function [theta1, rho1, theta2, rho2] = find_parallel(edges, bin_threshold)
% 利用霍夫变换寻找平行线

edges_bin = edges > bin_threshold;
[h, thetas, rhos] = hough(edges_bin);
%figure, imagesc(h);

peaks = houghpeaks(h,2);
rho1=rhos(peaks(1,1));
theta1=thetas(peaks(1,2))/180*pi;

if theta1 < -pi/4 || pi/4 < theta1
    split = size(h,2)/2;
    h_left = flip(h(:,1:split),1);
    h_right = h(:,split+1:end);
    h = [h_right h_left];
    %figure, imagesc(h);
    thetas = [thetas(split+1:end) thetas(1:split)];
    
    peaks = houghpeaks(h,2);
    rho1=rhos(peaks(1,1));
    theta1=thetas(peaks(1,2))/180*pi;
end

rho2=rhos(peaks(2,1));
theta2=thetas(peaks(2,2))/180*pi;

