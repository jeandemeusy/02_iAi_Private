function [tDHB] = DenavitHartenberg(d,theta)


tD     = [ 1 0 d;
           0 1 0;
           0 0 1 ];
 
tTheta = [ cos(theta) -sin(theta) 0;
           sin(theta)  cos(theta) 0 ;
                0           0     1 ];  

             
tDHB= tD * tTheta;

