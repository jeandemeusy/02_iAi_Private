%% Initialisation
close all; clear; clc;

%% Code
p1 = [50 150];
p2 = [350 350];
angles = [231.1 123];

subplot(1,3,1);
s = dominos_trajectory(p1,p2,angles,15);
xlabel('Position x - mm');
ylabel('Position y - mm');
zlabel('Position z - mm');
view([0 90]);


p1 = [150 150];
p2 = [350 100];
angles = [90 18];

subplot(1,3,2);
s = dominos_trajectory(p1,p2,angles,15);
xlabel('Position x - mm');
ylabel('Position y - mm');
zlabel('Position z - mm');
view([0 90]);

p1 = [50 50];
p2 = [350 350];
angles = [-45 -45];

subplot(1,3,3);
s = dominos_trajectory(p1,p2,angles,15);
xlabel('Position x - mm');
ylabel('Position y - mm');
zlabel('Position z - mm');
view([0 90]);

