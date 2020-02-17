%% Initialisation
close all; clear; clc;

%% Param�tres
% Param�tres du segment
step = 1; maxH = 30; 
numSeg = 4;

% Param�tre du cercle
r = 12;

% Param�tres d'affichage et enregistrement
modulo = 6; displayOldRect = 1;
record = 0; fileName = 'TEST.avi'; fps = 50;

%% Cr�ation des donn�es
[x,y,rot] = createCurve(numSeg,maxH,step,r);

%% Affichage
displayCurve(x,y,rot,r,maxH,numSeg,[14 25],'yellow',record,modulo,displayOldRect,fileName,fps);


