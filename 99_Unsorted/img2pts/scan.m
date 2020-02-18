%% scan.m
% Cette fonction défini les paramètres nécessaire au fastflood (parcourt de
% l'image pour détecter les pixels blancs consécutifs).
%
% La fonction recoit en entrée le chemin d'accès à une image.
%
% Elle renvoi trois paramètres :
%
% * dataOUT : structure de données comprenant la largeur de la lettre ainsi
% que la chaine d'instruction compressée
% * outImg : image d'entrée a laquelle a été retiré les pixels détectés par
% l'algorithme
% * borderList : une matrice comprenant la coordonnée (x,y) de chaque pixel
% détecté
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% Définition de la fonction
function [dataOUT,outImg,borderList] = scan(path)

imgIn   = imread(path);
imgEdge = double(imgIn)/255;

%% Fastflood
connectivity = [ 1 1 0 -1 -1 -1 0  1 ; 
                 0 1 1  1  0 -1 -1 -1]; % Matrice de connectivité - 8 

[dataOUT,outImg,borderList] = fastFlood(imgEdge, connectivity);

% Ajustement de la coordonnée 'y' des pixels, pour l'affichage
borderList(:,2) = 75 - borderList(:,2); 