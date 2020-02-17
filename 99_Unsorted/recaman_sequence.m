% recaman_sequence.m--
%
% Syntax:
%
% e.g.,

% Developed in Matlab 9.7.0.1190202 (R2019b) on PCWIN64.
% JDU - Jean Demeusy (jean.demeusy@heig-vd.ch), 2019-11-06 10:55
%-------------------------------------------------------------------------

%% Setup
close all;
clear;
clc;

%% Variable
n = 33; % Number of terms in the sequence
div = 20; % Number of step to compose a half-circle
record = 1;
A = zeros(1,n);


%% Algorithm to create the sequence
for k = 1:n-1 
    b = A(k) - k;
    A(k + 1) = b + 2*k;
    
    if b > 0 && ~any(A == b)
        A(k + 1) = b;
    end
    
end

xs = zeros((n-1)*div+1,1);
ys = zeros((n-1)*div+1,1);
for k = 2:n
    x = (A(k)+A(k-1))/2;
    r = (A(k)-A(k-1))/2;
    th = 0:pi/div:pi;
    
    if A(k) > A(k-1)
        xunit = r * cos(th) + x;
        yunit = r * sin(th);
    else
        xunit = -r * cos(th(end:-1:1)) + x;
        yunit = -r * sin(th(end:-1:1));
    end
    
    xs(1+((k-2)*div:(k-1)*div)) = xunit(end:-1:1);
    if mod(k,2) == 0
        ys(1+((k-2)*div:(k-1)*div)) = -yunit;
    else
        ys(1+((k-2)*div:(k-1)*div)) = yunit;
    end
end

%% Display
hold on;
axis equal;
set(gca,'xticklabel',[])
set(gca,'xtick',[])
set(gca,'yticklabel',[])
set(gca,'ytick',[])
box on;

if (record)
    myVideo = VideoWriter('myVideoFile','MPEG-4');
    myVideo.FrameRate = 24;
    myVideo.Quality = 100;
    open(myVideo);
end

for k = 2:length(xs)
    xlim([min(xs(1:k)) - 5, max(xs(1:k)) + 5]);
    XL = xlim;
    v_length = (XL(2)-XL(1))*5/7;
    ylim([-v_length/2 v_length/2]);
    pause(1/512);
    plot(xs(k-1:k),ys(k-1:k),"Color",hsv2rgb([k/length(xs),1,1]),"LineWidth",2);
    
    if (record)
        frame = getframe(gcf); %get frame
        writeVideo(myVideo, frame);
    end
end

if (record)
    close(myVideo)
end
