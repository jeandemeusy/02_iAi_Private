%% Initialisation
close all;
clear;
clc;

%%  Paramètres
theta = 0:0.001:(2*pi);
numElements = 5;
offElements = 0;

figure;
for p = (1+offElements):(numElements+offElements)
    for q = (1+offElements):(numElements+offElements)
        if p == q-1 || q == p-1
            x = sin(p*theta);
            y = sin(q*theta + pi/2);
            
            iSubplot = (p-1-offElements)*numElements + q-offElements;
            subplot(numElements,numElements,iSubplot);
            plot(x,y,'k','LineWidth',1); axis square; axis off;
        end
    end
end

%% Rhodonea curve
theta = 0:0.001:(20*pi);
numElements = 10;
offElements = 0;

figure;
for p = (1+offElements):(numElements+offElements)
    for q = (1+offElements):(numElements+offElements)
        k = p/q;
        x = cos(k*theta).*cos(theta);
        y = cos(k*theta).*sin(theta);
        
        iSubplot = (p-1-offElements)*numElements + q-offElements;
        subplot(numElements,numElements,iSubplot);
        plot(x,y,'k','LineWidth',1); axis square; axis off;      
    end
end

