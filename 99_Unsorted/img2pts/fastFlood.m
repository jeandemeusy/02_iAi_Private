%% fastFlood.m
% Cette fonction effectue un flood (d�tection des pixels blanc) d'une
% image. Elle parcourt en premier l'image de gauche � droite et de haut en
% bas jusqu'� trouver le premier pixel blanc, puis applique l'algorithme du
% 'Freeman Chain Code' pour d�tecter les suivants.
%
% Cette fonction recoit en entr�e deux param�tres : 
%
% * imgIN : l'image sur laquelle on souhaite d�tecter une forme
% * connectivity : matrice de connectivit� qui d�fini quels voisins nous
% int�resse.
% 
% Elle renvoit trois param�tres : 
% 
% * dataOUT : structure de donn�es comprenant la largeur de la lettre ainsi
% que la chaine d'instruction compress�e
% * imgOUT : image d'entr�e a laquelle a �t� retir� les pixels d�tect�s par
% l'algorithme
% * borderList : une matrice comprenant la coordonn�e (x,y) de chaque pixel
% d�tect�.
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% D�finition de la fonction
function [dataOUT,imgOUT,borderList]= fastFlood(imgIN, connectivity)
nLine = 1;
nColumn = 1;
p0 = [0,0];
freeman = [];

%% D�tection du premier pixel blanc de l'image
while(sum(p0 == [0,0]) ~= 0)
    if imgIN(nLine,nColumn) == 1
        p0 = [nColumn,nLine];
    else
        nColumn = nColumn + 1;
        if nColumn == size(imgIN,2) + 1
            nColumn = 1;
            nLine = nLine + 1;
        end
    end
end
objectSize = 1;

imgIN(p0(2),p0(1)) = 0.5;
borderList(1,:) = p0;

% Parcourt du reste de l'image en partant du dernier pixel d�tect�
isStartPoint = 0;
while(~isStartPoint)
    p0 = borderList(objectSize,:);
    for i = 1:8
        p = p0 + connectivity(:,i)';
        
        if(p(1) == borderList(1,1) && p(2) == borderList(1,2))
            isStartPoint = 1;
            break;
        elseif(imgIN(p(2),p(1)) == 1)
            borderList(end+1,:) = p;
            imgIN(p(2),p(1)) = 0.5;
            objectSize = objectSize +1;
            freeman(end+1) = i;
            break;
        end
        
    end
end
borderList(end+1,:) = borderList(1,:);
freeman(end+1) = 8;
dataOUT.letterWidth = max(borderList(:,1)) - min(borderList(:,1));

%% Cr�ation de la chaine � partir des directions (num�riques) d�tect�es
chain = '';
for j = 1:length(freeman)
    chain = [chain num2str(freeman(j))];
end

%% Compression de la chaine
%dataOUT.chain = compressDir(chain);
dataOUT.chain = chain;
%% Image de sortie
imgOUT = imgIN;