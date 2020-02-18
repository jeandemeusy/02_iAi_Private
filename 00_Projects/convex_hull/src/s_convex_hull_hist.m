%% Initialisation
clear; close all; clc;

%% Vecteurs x et y
numPoint = 150;
x = normrnd(0,10,[numPoint 1]);
y = normrnd(0,10,[numPoint 1]);

%% Convex Hull
figure;
subplot(1,2,1);
f_convex_hull(x,y,true,0.01);

%% Distribution
for j = 1:100
    x = normrnd(0,10,[numPoint 1]);
    y = normrnd(0,10,[numPoint 1]);
    
    %% Enveloppe convexe des points (x,y)
    PoB = f_convex_hull(x,y,false);
    PoB(end+1,:) = PoB(1,:);
    perimeter = 0;
    
    for i = 1:length(PoB)-1
        P1 = PoB(i,:);
        P2 = PoB(i+1,:);
        perimeter = perimeter + sqrt((P2(1)-P1(1))^2 + (P2(2)-P1(2))^2);
    end
    
    dist(j) = perimeter;
    
    clc;
    disp(['iteration : ' num2str(j)]);
end

%% Histograme de distribution du perimetre
subplot(1,2,2);
hist(dist,round(sqrt(length(dist))));
title(['mean: ' num2str(round(mean(dist),2)) ' - std: ' num2str(round(std(dist),2))]);