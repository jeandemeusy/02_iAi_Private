%% Initialisation
close all; clear; clc;

p0 = [237;174];

%% Matrices Denavit-Hartenberg
fEpaule = [eye(2) [p0(1);p0(2)];0 0 1];

fHip   = fEpaule* MGD([0 95 ],[deg2rad(123) 0]);
fKnee  = fHip   * MGD([0 65],[deg2rad(-70) 0]);
fAnkel = fKnee  * MGD([0 87],[deg2rad(32) 0]);
fFeet  = fAnkel * MGD([0 75],[deg2rad( 2) 0]);
fToe   = fFeet  * MGD([0 25],[deg2rad(37) 0]);

rHip    = fEpaule* MGD([0 240],[deg2rad(11) 0]);
rKnee   = rHip   * MGD([0 85],[deg2rad(94) 0]);
rAnkel  = rKnee  * MGD([0 88],[deg2rad( -49) 0]);
rFeet   = rAnkel * MGD([0 89],[deg2rad( 32) 0]);
rToe    = rFeet  * MGD([0 25],[deg2rad( 35) 0]);

hHead   = fEpaule* MGD([0 190],[deg2rad(-140) 0]);
hMouth  = hHead  * MGD([0 100],[deg2rad(-100) 0]);

%% Coordonnées des articulations
fLegXY = [p0 fEpaule(1:2,3) fHip(1:2,3) fKnee(1:2,3) fAnkel(1:2,3) fFeet(1:2,3) fToe(1:2,3)];
rLegXY = [p0 rHip(1:2,3) rKnee(1:2,3) rAnkel(1:2,3) rFeet(1:2,3) rToe(1:2,3)];
headXY = [p0 hHead(1:2,3) hMouth(1:2,3)];

%% Affichage
imshow('standingHorse.png'); hold on;
p1 = plot(fLegXY(1,:),fLegXY(2,:),'ko-');
p2 = plot(rLegXY(1,:), rLegXY(2,:),'ko-'); 
p3 = plot(headXY(1,:), headXY(2,:),'ko-'); 

p1.LineWidth = 2; p1.MarkerSize = 8;
p2.LineWidth = 2; p2.MarkerSize = 8;
p3.LineWidth = 2; p3.MarkerSize = 8;
