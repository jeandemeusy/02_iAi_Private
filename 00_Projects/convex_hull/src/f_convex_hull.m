function [PoB] = FconvexHull(x,y,disp,pauseTime)
if nargin == 2
    disp = false;
end
if nargin == 3
    pauseTime = 0.05;
end

%% Point initial
[~,indexSorted] = sortrows([x y],[2 1],{'ascend','descend'});
ixLowerLeft = indexSorted(1);

%% Calcul de l'angle entre chaque point et le point initial
angle = atan2(y-y(ixLowerLeft),x-x(ixLowerLeft));
pointData = sortrows([x y angle],[3 2 1]);

%% Initialisation du tableau de points de l'enveloppe
PoB(1,:) = pointData(1,1:2);

%% Initialisation de l'affichage
circSize = 40*ones(1,length(x));

color = ones(length(x),1) .* [1,0,0];
color(1,:) = [0 0 1];
if disp
  
    p1 = scatter(pointData(:,1),pointData(:,2),10,'CData',color); hold on;    
    p2 = plot(0,0,'ro-','MarkerSize',8,'LineWidth',1.5);
end

%% Calcul des autres points de l'enveloppe
for i = 2:length(pointData)
    pointAdded = false;
    if disp
        circSize(i) = 1;
        color(i,:) = [0 0 1];
        set(p1,'XData',pointData(:,1),'YData',pointData(:,2),'CData',color);
    end
    while ~pointAdded
        if size(PoB,1) > 2
            area = det([PoB(end-1,:) 1; PoB(end,:) 1; pointData(i,1:2) 1]);
            
            if area > 0
                PoB(end+1,:) = pointData(i,1:2);
                pointAdded = true;
            else
                PoB(end,:) = [];
            end
        else
            PoB(end+1,:) = pointData(i,1:2);
            pointAdded = true;
        end
       
        if disp
            set(p2,'XData',PoB(:,1),'YData',PoB(:,2));
            pause(pauseTime);
        end
    end
end

%% Fermeture de l'enveloppe avec le point initial
if disp
    set(p2,'XData',[PoB(:,1);PoB(1,1)],'YData',[PoB(:,2);PoB(1,2)]);
    pause(pauseTime);
end