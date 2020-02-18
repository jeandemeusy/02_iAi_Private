function [x,y] = rotate2Dpoint(x0,y0,alpha)

for i = 1:length(x0)
    p = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]*[x0(i);y0(i);1];
    
    x(i) = p(1);
    y(i) = p(2);
end