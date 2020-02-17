%% Initialisation
close all; clear; clc;

%% Paramètres
% Paramètres du segment
step = 1; maxH = 30; 
numSeg = 4;

% Paramètre du cercle
r = 12;

% Paramètres d'affichage et enregistrement
modulo = 6; displayOldRect = 1;
record = 0; fileName = 'TEST.avi'; fps = 50;

%% Création des données
[x,y,rot] = createCurve(numSeg,maxH,step,r);

%% Affichage
displayCurve(x,y,rot,r,maxH,numSeg,[14 25],'yellow',record,modulo,displayOldRect,fileName,fps);


