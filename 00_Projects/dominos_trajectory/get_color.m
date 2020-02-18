function color = getColor(i,N)
initColor = [0 0 1];
lastColor = [1 0 0];

col(1,:) = linspace(initColor(1),lastColor(1),N);
col(2,:) = linspace(initColor(2),lastColor(2),N);
col(3,:) = linspace(initColor(3),lastColor(3),N);

color = [col(1,i) col(2,i) col(3,i)];
