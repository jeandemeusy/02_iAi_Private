% psychedelicArt.m--
%
% Syntax:
%
% e.g.,

% Developed in Matlab 9.6.0.1072779 (R2019a) on PCWIN64.
% JDU - Jean Demeusy (jean.demeusy@heig-vd.ch), 2019-05-16 16:20
%-------------------------------------------------------------------------

%% Setup
close all;
clear;
clc;

%% Variable

for k = 1:4
    func = @(x)(sin(x*pi-pi)+1)/250;
    im = perlinMultiD([1080/4 1960/4 3], func);
    
    %% Code
    for i = 1:3
        im(:,:,i) = imadjust(real(im(:,:,i)));
    end
    
    im = imresize(im,4,"lanczos3");
    
    subplot(2,2,k);
    imshow(im,[]);
end

%% Display
% displayImages(im);