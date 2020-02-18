%% img2pts.m (main)
%
% Code Matlab principal, permettant de convertir une image (contours
% visibles uniquement) en une chaine compacte de directions permettant
% son parcourt dans le sens horaire.
%
% Auteurs : Jean DEMEUSY, Cyril RAMSEIER

%% Initialisation
close all; 
clear; 
clc;

%% Code
filesProp = dir('Letters/*.png');
numFiles = length(filesProp);

% Calcul de la taille du subplot
[W,H] = minPerimeterForArea(numFiles,0); 

for i = 1:numFiles
    %% Création des directions
    fileName = filesProp(i).name;
    path = ['Letters/' fileName];
    
    % Scan et fastflood de l'image
    [dataOUT,~,borderList] = scan(path);

    %% Création du fichier .txt
    create = true;
    strToPrint = [num2str(dataOUT.letterWidth) ',' dataOUT.chain];
    if create
        fid = fopen(['textFiles/' fileName(1:end-4) '.txt'], 'w');
        fprintf(fid,'%s', strToPrint);
        fclose(fid);
    end

    %% Affichage
    display = true;
    if display
        h = subplot(W,H,i);
        plot(borderList(:,1),borderList(:,2),'k','LineWidth',1.5); axis square; axis off;
        ylim([0 75]); xlim([0 75]);
    end
end