%% Initialisation
clear; close all; clc;

%% Vecteurs x et y
% numPoint = 150;
% x = normrnd(0,10,[numPoint 1]);
% y = normrnd(0,10,[numPoint 1]);

vecLetters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
[H, W] = xsubplot(length(vecLetters)+2);

figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(vecLetters)
    img = imread(strcat("../assets/",vecLetters(i),".png"));
    [y,x] = find(img);
    y = 75 - y;

    %% Convex Hull
    subplot(H,W,i)
    f_convex_hull(x,y,true,0);
end