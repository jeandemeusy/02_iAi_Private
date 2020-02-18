%% minPerimeterForArea.m
% Cette fonction permet de calculer le nombre de ligne et de colonne du
% subplot, bas� sur le nombre d'�l�ment � afficher.
%
% La fonction recoit deux param�tres en entr� :
% 
% * area : nombre d'�l�ment � afficher
% * mainOff : coefficient (default = 0) qui permet d'ajuster, si possible, le
% ratio lignes/colonnes.
%
% Elle renvoit deux valeurs , W et H, qui sont le nombre de lignes et de
% colonnes du subplot.
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% D�finition de la fonction
function [W,H] = minPerimeterForArea(area,mainOff)
if nargin == 1 ,mainOff = 0; end

divs = divisors(area);
nDivs = length(divs);

if nDivs == 2 && area ~= 2
    [W,H] = minPerimeterForArea(area+1,mainOff);
else
    ix = find((divs+divs(nDivs:-1:1)) == min(divs + divs(nDivs:-1:1)),1);
    
    if ix > mainOff,    off = mainOff;
    else,               off = 0;
    end
    
    W = divs(ix - off);
    H = area / W;
end