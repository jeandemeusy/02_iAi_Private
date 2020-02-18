%% Initialisation
close all; close; clc;

%% Code
mainFolder = 'textFiles/';
filesProp = dir([mainFolder '*.txt']);
numFiles = length(filesProp);
lengths = zeros(numFiles,2);

letters = cell(1,numFiles);

for i = 1:numFiles
    %% Création des directions
    fileName = filesProp(i).name;
    letters{i} = filesProp(i).name(1);
    path = [mainFolder fileName];
    
    fileID = fopen(path,'r');
    str = char(string(textscan(fileID,'%s')));
    fclose(fileID);
    
    ix = find(str == ',');
    str = str((max(ix)+1):end);
    
    [shortPP] = compressDir(str);
    
    lengths(i,:) = [length(str),length(shortPP)];
end

maxY = ceil(max(lengths(:))/100)*100;
plot(lengths,'o-','LineWidth',1); hold on;
plot([1 26],[128 128],'k--','LineWidth',1);

axis([1 26 0 maxY])
xlabel('Caractère'); ylabel('Longueur de la chaine d''instructions');
legend('Standard','Raccourcie','Limite = 128','Location','Best');
xticks(1:26); xticklabels(letters); grid; 
