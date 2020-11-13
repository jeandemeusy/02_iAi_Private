%% Initialisation
clear; close all; clc;

%% Vecteurs x et y
numPoint = 150;
x = normrnd(0,10,[numPoint 1]);
y = normrnd(0,10,[numPoint 1]);

%% Convex hull
f_convex_hull(x,y,true,0);