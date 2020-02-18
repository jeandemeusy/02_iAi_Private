function [success] = dominos_trajectory(p1,p2,theta,N)
%% Rotation des points
if theta(2) - theta(1) == -45
    shiftAng = -pi/8;
elseif xor(theta(1) == 0,theta(2) == 0)
    shiftAng = -mean(theta);
elseif theta(1) == 0 && theta(2) == 0
    shiftAng = -pi/2;
else
    shiftAng = 0;
end

alpha = deg2rad(theta(1)) + shiftAng - pi/2;
beta  = deg2rad(theta(2)) + shiftAng - pi/2;

[x1,y1] = rotate_2D_point(p1(1),p1(2),shiftAng);
[x2,y2] = rotate_2D_point(p2(1),p2(2),shiftAng);

%% Détermination des coefficients (a,b,c,d) de la fonction degré 3
A = [  x1^3 x1^2  x1 1;
       x2^3 x2^2  x2 1;
      3*x1^2 2*x1  1 0;
      3*x2^2 2*x2  1 0  ];
B = [y1; y2; tan(alpha); tan(beta)];

X = A\B;

%% Trajectoire à suivre
[~,~,height] = get_dimensions();

xTraj = x1:sign(x2-x1)*0.01:x2;
yTraj = polyval(X,xTraj);
zTraj = height/2 * ones(1,length(xTraj));

%% Position pour pousser le premier domino
slope = @(x) 3*x^2*X(1) + 2*x*X(2) + X(3);
tgte  = @(x) slope(x1)*(x-x1) + y1;

xInit = x1 - sign(x2-x1)*20;
yInit = tgte(xInit);
zInit = height/2;

%% Dominos intermédiaires
dist = sqrt((xTraj(2:end)-xTraj(1:end-1)).^2 + (yTraj(2:end)-yTraj(1:end-1)).^2);
xDom = zeros(1,N);
yDom = zeros(1,N);
aDom = zeros(1,N);

for i = 1:N
    distDomino = sum(dist) * i/(N+1);
    temp = cumsum(dist) - distDomino;
    idx = find(min(abs(temp)) == abs(temp));
    
    xDom(i) = xTraj(idx);
    yDom(i) = yTraj(idx);
    aDom(i) = atan(slope(xDom(i)));
end

%% Rotations aux positions initiales
[xTraj,yTraj] = rotate_2D_point(xTraj,yTraj,-shiftAng);
[xDom,yDom]   = rotate_2D_point( xDom, yDom,-shiftAng);
[xInit,yInit] = rotate_2D_point(xInit,yInit,-shiftAng);

%% Affichage
% Trajectoire
plot3(xTraj,yTraj,zTraj,'k:','LineWidth',2); hold on; axis equal

% Position pour pousser le premier domino
p = plot3(xInit,yInit,zInit,'o','MarkerSize',12);
p.MarkerFaceColor = 0.42*ones(1,3);
p.MarkerEdgeColor = p.MarkerFaceColor;

% Dominos de départ et de fin
display_domino(p1,rad2deg(alpha-shiftAng),get_color(  1,N+2));
display_domino(p2,rad2deg( beta-shiftAng),get_color(N+2,N+2));

% Dominos intermédiaires
for i = 1:length(xDom)
    display_domino([xDom(i) yDom(i)],rad2deg(aDom(i)-shiftAng),get_color(i+1,N+2));
end

% Sol
P = patch('faces',1:4,'vertices',[0 0;0 400;400 400;400 0]);
set(P,'FaceColor','k','FaceAlpha',.1,'EdgeColor','none');

% Legende
lgd = legend('Trajectoire','Position initiale','Début','Fin');
lgd.Color = 'none';
lgd.EdgeColor = 'none';

%% Succes ou pas succes ?
success = (height >  (sum(dist) * 1/(N+1)));