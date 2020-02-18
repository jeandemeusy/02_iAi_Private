%% compressDir.m
% Cette fonction permet de convertir une chaine composée de valeurs
% numérique en une chaine compact. Exemple : '11113334555' -> '4A3CD3E'
%
% Elle recoit une entrée une chaine (str), et renvoi une chaine compacte
% (shortStr).
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% Définition de la fonction
function [shortStr] = compressDir(str)

alphabet = ['A';'B';'C';'D';'E';'F';'G';'H'];

 strLen = length(str);
%% Transformation de 1234 -> ABCD
for i = 1:strLen
    str(i) = alphabet(str2double(str(i)));
end

%% Concatenation des suites de directions identiques
currentDir = str(1);
numCurrentDir = 1;
shortStr = '';

for i = 2:strLen
    if(str(i) == currentDir)
        numCurrentDir = numCurrentDir + 1;
    else
        if numCurrentDir > 1
            numInStr = num2str(numCurrentDir);
            shortStr(end+1:end+length(numInStr)) = numInStr;
        end
        shortStr(end+1) = currentDir;
        
        currentDir = str(i);
        numCurrentDir = 1;
    end
    if i == strLen
        if numCurrentDir > 1
            numInStr = num2str(numCurrentDir);
            shortStr(end+1:end+length(numInStr)) = numInStr;
        end
        shortStr(end+1) = currentDir;
    end
end

