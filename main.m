clear all;
clc;


img = imread("./data/3.jpg");
imshow(img);

edges = compute_edges(img,5);
imshow(edges);