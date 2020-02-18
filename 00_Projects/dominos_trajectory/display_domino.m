function displayDomino(pos,angle,color)
[depth,width,height] = get_dimensions();

V = [0 0 0; depth 0 0; depth width 0; 0 width 0;
    0 0 height; depth 0 height; depth width height;
    0 width height] - [depth width 0]/2;

F = [1 2 3 4; 5 6 7 8; 1 2 6 5;
    2 3 7 6; 3 4 8 7; 4 1 5 8];

V1 = V + [pos(1) pos(2) 0];

P = patch('faces',F,'vertices',V1);
set(P,'FaceColor',color,'FaceAlpha',.5,'EdgeColor',color);
rotate(P,[0 0 1],angle,[pos(1) pos(2) 0])