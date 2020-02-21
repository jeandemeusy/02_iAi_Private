%{
barrel_correction.m--

Syntax: 

e.g.,   

Developed in Matlab 9.7.0.1296695 (R2019b) Update 4 on PCWIN64

for the iAi institute, HEIG-VD (http://iai.heig-vd.ch/).
JDU - Jean Demeusy (jean.demeusy@heig-vd.ch), 2020-02-21
------------------------------------------------------------------------
%}
%% Setup
close all;
clear;
clc;

%% Variables
k1 = -0.00925;
img_num = 2;
r_u_model = @(r,k) r + k*r.^3;

%% Input
load("../assets/data.mat");
I = images{img_num};
I = double(I(:,:,1));
[H,W] = size(I);

%% Algorithm
[x,y] = meshgrid(1:W,1:H);
x = x - W/2;
y = y - H/2;

% distance-to-center matrix
r_d = sqrt(x.^2+y.^2);
max_r = max(r_d(:));
r_d = r_d/max_r;

% angle-to-center matrix
theta = atan2(y,x);

% undistored distance-to-center matrix
r_u = r_u_model(r_d,k1);

% undistored cartesian references
x_u = r_u .* cos(theta) * max_r;
y_u = r_u .* sin(theta) * max_r;

% undistored references applied to a distored image
img_interp = interp2(x,y,I,x_u,y_u);

%% Display
imshowpair(img_interp,double(I));

%% Functions

