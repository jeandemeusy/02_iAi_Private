function circle(x,y,r, color)
%%Plots circle of radius r at position (x,y) of color 'color'
pos = [x-0.5*r y-0.5*r r r];
rectangle('Position',pos,'Curvature',[1 1],'FaceColor',color)
end