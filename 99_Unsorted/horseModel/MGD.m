function [T0Tn] = MGD(d, theta)
T0Tn = eye(3);

for i = 1:length(d)
    tTheta = [rotz(theta(i)) zeros(2,1); zeros(1,2) 1];
    
    tD = eye(3);
    tD(1,3) = d(i);

    
    T0Tn = T0Tn * tD * tTheta;
end