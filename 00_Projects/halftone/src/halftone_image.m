%{
halftone_image.m--

Syntax: 

e.g.,   

Developed in Matlab 9.7.0.1296695 (R2019b) Update 4 on PCWIN64

for the iAi institute, HEIG-VD (http://iai.heig-vd.ch/).
JDU - Jean Demeusy (jean.demeusy@heig-vd.ch), 2020-02-25
------------------------------------------------------------------------
%}
%% Setup
close all;
clear;
clc;

%% Variables
load("../assets/data.mat");

%% Algorithm
halftone(img_set{3},12,10,'k');

%% Display

%% Functions

