%% scan.m
% Cette fonction d�fini les param�tres n�cessaire au fastflood (parcourt de
% l'image pour d�tecter les pixels blancs cons�cutifs).
%
% La fonction recoit en entr�e le chemin d'acc�s � une image.
%
% Elle renvoi trois param�tres :
%
% * dataOUT : structure de donn�es comprenant la largeur de la lettre ainsi
% que la chaine d'instruction compress�e
% * outImg : image d'entr�e a laquelle a �t� retir� les pixels d�tect�s par
% l'algorithme
% * borderList : une matrice comprenant la coordonn�e (x,y) de chaque pixel
% d�tect�
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% D�finition de la fonction
function [dataOUT,outImg,borderList] = scan(path)

imgIn   = imread(path);
imgEdge = double(imgIn)/255;

%% Fastflood
connectivity = [ 1 1 0 -1 -1 -1 0  1 ; 
                 0 1 1  1  0 -1 -1 -1]; % Matrice de connectivit� - 8 

[dataOUT,outImg,borderList] = fastFlood(imgEdge, connectivity);

% Ajustement de la coordonn�e 'y' des pixels, pour l'affichage
borderList(:,2) = 75 - borderList(:,2); 