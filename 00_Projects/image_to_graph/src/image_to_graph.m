function [PLOT,ORI,numObj] = image2graph(IM_RAW,xMIN,xMAX,yMIN,yMAX,disp)
%% Code
IM_BIN = imbinarize(IM_RAW);
IM_OPEN = imerode(IM_BIN,strel('disk',2));

%% Hough transform
[H,T,R] = hough(1-IM_OPEN);
P  = houghpeaks(H,2,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(1-IM_OPEN,T,R,P,'FillGap',60,'MinLength',25);

if disp
    imshow(IM_RAW); hold on;
end

for k = 1:length(lines)
    % Determine the endpoints of the longest line segment
    len(k) = norm(lines(k).point1 - lines(k).point2);
    xy((k-1)+(k:k+1),:) = [lines(k).point1; lines(k).point2];
    
    ORI(k) = lines(k).theta;
    
    m(k) = -1/tan(deg2rad(ORI(k)));
    b(k) = xy(2*k-1,2) - m(k)*xy(2*k-1,1);
    
    if disp
        plot(xy((k-1)+(k:k+1),1),xy((k-1)+(k:k+1),2),'bs','MarkerSize',8);
    end
end

xP_INTER = (b(2)-b(1)) / (m(1)-m(2));
yP_INTER = m(1) * xP_INTER + b(1);

if(isnan(xP_INTER) && isnan(yP_INTER))
    xP_INTER = lines(2).point1(1);
    yP_INTER = lines(1).point2(2);
end

if disp
    plot(xP_INTER,yP_INTER,'bs','MarkerSize',12);
    
end

ORI = ORI(min(abs(ORI)) == abs(ORI));
T = [cosd(ORI) -sind(ORI) ; sind(ORI) cosd(ORI)];

%% Object
S = regionprops(bwconncomp(1-IM_OPEN,4),'Centroid','Area');

vecI = setdiff(1:length(S),find(max([S.Area])));
numObj = length(vecI);
for iI = 1:numObj
    i = vecI(iI);
    
    CENTER(iI,:) =  S(i).Centroid;
end

if disp
    plot(CENTER(:,1),CENTER(:,2),'ro','MarkerSize',4);
end

%% Plot
for iI = 1:numObj
    CENTER(iI,:) = CENTER(iI,:) - [xP_INTER  yP_INTER - size(IM_OPEN,1)];
    
    PLOT(iI,1) = CENTER(iI,1);
    PLOT(iI,2) = size(IM_OPEN,1) - CENTER(iI,2);
end

for i = 1:length(PLOT)
    PLOT(i,:) = T*PLOT(i,:)';
end

%% AXES
for iI = 1:length(xy)
    xy(iI,:) = xy(iI,:) - [xP_INTER  yP_INTER - size(IM_OPEN,1)];
    
    xy(iI,1) = xy(iI,1);
    xy(iI,2) = size(IM_OPEN,1) - xy(iI,2);
end

for i = 1:length(xy)
    xy(i,:) = T*xy(i,:)';
end

PLOT(:,1) = map(PLOT(:,1),min(xy(1:2,1)),max(xy(1:2,1)),xMIN,xMAX);
PLOT(:,2) = map(PLOT(:,2),min(xy(3:4,2)),max(xy(3:4,2)),yMIN,yMAX);


PLOT = sortrows(PLOT, 1);