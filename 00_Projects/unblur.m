clear;
close all;
clc;

%% Code
I = im2double(imread("photo_2020-05-26 16.15.10.jpeg"));
subplot(1,2,1); imshow(I), title('Source image');

%PSF
PSF = fspecial('disk',8);
noise_mean = 0;
noise_var = 0.001;
estimated_nsr = noise_var / var(I(:));

I = edgetaper(I,PSF);
subplot(1,2,2); imshow(deconvwnr(I,PSF, estimated_nsr)); title('Result');