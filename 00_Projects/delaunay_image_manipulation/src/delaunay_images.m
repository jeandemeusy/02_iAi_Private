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
load("../assets/data.mat");

%% Variable
img = img_set{8};
gray = rgb2gray(img);
bin = get_bin_image(gray);

W = size(img,2);
H = size(img,1);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

%% Code
PL = get_point_list(gray,sensitivity,inner_steps,border_num);
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
    
    if (~mod(idx,100) || idx==N)
        clc;
        display(['Tri. # ' num2str(idx) ' / ' num2str(N)]);
    end
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
function [list] = get_point_list(img,sensitivity,step,border_num)
stats = regionprops(edge(img,'Canny',[],sensitivity),'PixelList');

list = [];
for idx = 1:length(stats)
    list = [list ; stats(idx).PixelList];
end

list = list(1:step:end,:);
list = [list; get_border_point_list(img,border_num)];
end
function [list] = get_border_point_list(img,num_xy)
x_num = num_xy(1);
y_num = num_xy(2);

list = [
    [linspace(1,size(img,2),x_num)',     zeros(x_num,1)];
    [linspace(1,size(img,2),x_num)',     ones(x_num,1)*size(img,1)];
    [zeros(y_num,1),            linspace(1,size(img,1),y_num)'];
    [ones(y_num,1)*size(img,2), linspace(1,size(img,1),y_num)']
    ];
end
function [bin] = get_bin_image(img)
bin = img > 240;
bin = imfill(~bin,'holes');
bin = ~imclose(bin,strel('disk',2));
end
