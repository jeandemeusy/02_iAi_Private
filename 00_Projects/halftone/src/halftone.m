function h = halftone(X,block_size, detail, color)
%%Creates halftone images%%
%%Written by Aqeel Anwar (aqeel.anwar@gatech.edu)

% % Inputs:
% % X: Image that needs to be halftoned
% % block_size: Size of the blocks created in the image for halftonning.
% % detail: Controls the radius of the circle being plotted in each block. details<=block_size;
% % color: Color of the circles plotted. Examples 'r', 'k', 'y' etc

%%Usage:
% % X = imread('lena.jpg');
% % h=halftone(X,10,10,'r');



if length(size(X))>2
    X = rgb2gray(X);
end

if(detail>block_size)
    disp('Error:Value of detail must be less than the block_size.');
    h=[];
else
    
    X = im2double(X);
    [m n] = size(X);
    fun = @(block_struct) mean(mean(block_struct.data));
    I2 = blockproc(X,[block_size block_size],fun);
    I2 = I2- min(min(I2));
    
    Imax = max(max(I2));
    delta = Imax/detail;
    I2r = ceil(I2/delta);
    I2r = block_size-I2r;
    I2r = flipud(I2r);
    
    midpoints_y = [block_size/2:block_size:m];
    midpoints_x = [block_size/2:block_size:n];
    h=figure;

    for i=1:length(midpoints_x)
        for j=1:length(midpoints_y)
            circle(midpoints_x(i), midpoints_y(j), I2r(j,i), color);
            hold on
        end
    end
    axis equal
    %set(gca,'visible','off')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'color',[1 1 1])

end
end