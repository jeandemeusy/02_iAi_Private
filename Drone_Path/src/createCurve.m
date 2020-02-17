function [x,y,rot] = createCurve(numSeg,maxH,step,r)
num   = 2*maxH/step+1;
H     = linspace(-maxH,maxH,num);
angle = linspace(pi/2,-pi/2,num*2/3);

H1     =   (-maxH-r):step:(-maxH-step);
H2     = (maxH+step):step:(maxH+r);
xCurve = r*cos(angle);
yCurve = r*sin(angle);

x = [];
y = [];
rot = [];

for i = 1:numSeg
    if ~mod(i,2), usedH = H(end:-1:1);
    else,         usedH = H;
    end
    x   = [x usedH];
    y   = [y (numSeg+1-2*i)*r*ones(1,num)];
    rot = [rot zeros(1,num)];

    if i ~= numSeg
        x   = [x -(-1)^i*(maxH+xCurve)];
        y   = [y yCurve+ (numSeg-2*i) * r];
        rot = [rot -(-1)^i*angle-pi/2 ];
    end
end
if ~mod(numSeg,2), usedH2 = H2(end:-1:1)-2*maxH-r;
else,              usedH2 = H2;
end
x = [H1 x usedH2];
y = [(numSeg-1)*r*ones(1,length(H1)) y (1-numSeg)*r*ones(1,length(H2))];
rot = [zeros(1,length(H1)) rot zeros(1,length(H2))];