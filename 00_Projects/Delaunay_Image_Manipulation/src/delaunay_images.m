% delaunay_images.m--
%
% Syntax:
%
% e.g.,

% Developed in Matlab 9.7.0.1190202 (R2019b) on PCWIN64.
% JDU - Jean Demeusy (jean.demeusy@heig-vd.ch), 2020-02-04 13:04
%-------------------------------------------------------------------------

%% Setup
close all;
clear;
clc;

%% Parameters
remove_background = false;  % Works only if input background is white
inner_steps = 100;           % Decimation for the points inside the image
border_step = 100;           % Decimation for the points on the border
sensitivity = sqrt(2);      % Sensitivity of the border detection

%% Variable
img = imread("../assets/gorilla_image.jpg");
gray = rgb2gray(img);
bin = get_bin_image(gray);

W = size(img,2);
H = size(img,1);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

%% Code
PL = get_point_list(gray,sensitivity,inner_steps,border_step);
mesh = delaunay(PL);
N = length(mesh);

outR = ones(size(gray))*255;
outG = outR;
outB = outR;

for idx = 1:N
    in = poly2mask(PL(mesh(idx,:),1),PL(mesh(idx,:),2),H,W);
    
    outR(in) = mean(R(in));
    outG(in) = mean(G(in));
    outB(in) = mean(B(in));
    
    clc;
    display(['Tri. # ' num2str(idx) ' / ' num2str(N)]);
end

if (remove_background)
    outR(bin) = 255;
    outG(bin) = 255;
    outB(bin) = 255;
end

%% Display
out = uint8(cat(3,outR,outG,outB));

figure;
subplot(1,2,1);     imshow(img,[]);
subplot(1,2,2);     imshow(out,[]);

%% Funtions
function [list] = get_point_list(img,sensitivity,step,border_step)
stats = regionprops(edge(img,'Canny',[],sensitivity),'PixelList');

list = [];
for idx = 1:length(stats)
    list = [list ; stats(idx).PixelList];
end

list = list(1:step:end,:);
list = [list; get_border_point_list(img,border_step)];
end
function [list] = get_border_point_list(img,step)
x_num = numel(1:step:size(img,2));
y_num = numel(1:step:size(img,1));

list = [
    [(1:step:size(img,2))',     zeros(x_num,1)];
    [(1:step:size(img,2))',     ones(x_num,1)*size(img,1)];
    [zeros(y_num,1),            (1:step:size(img,1))'];
    [ones(y_num,1)*size(img,2), (1:step:size(img,1))']
    ];
end
function [bin] = get_bin_image(img)
bin = img > 240;
bin = imfill(~bin,'holes');
bin = ~imclose(bin,strel('disk',2));
end