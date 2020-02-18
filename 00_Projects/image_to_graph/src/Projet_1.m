%% Initialisation
clear;
close all;
clc;

%% Paramètres
xMIN = -6; xMAX = 7;
yMIN = -3; yMAX = 8;

%% Code
img = double(imread('../assets/graph_04.png'))/255;
img = img(:,:,3);

subplot(2,1,1);
[pointList,ORI,numObj] = image_to_graph(img,xMIN,xMAX,yMIN,yMAX,true);
title(['Orientation: ' num2str(ORI) '°  Number: ' num2str(numObj)]);

H = subplot(2,1,2);
plot(pointList(:,1),pointList(:,2),'k.','MarkerSize',8); hold on;
plot([xMIN xMAX],[0 0],'k','LineWidth',1);
plot([0 0],[yMIN yMAX],'k','LineWidth',1);

xlim([xMIN xMAX] + [-1 1]*max(abs([xMIN xMAX]))/10); 
ylim([yMIN yMAX] + [-1 1]*max(abs([yMIN yMAX]))/10);
% xkcdify(H);