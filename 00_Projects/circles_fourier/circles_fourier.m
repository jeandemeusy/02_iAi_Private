function circles_fourier(mode,nCirc)
%% Valeurs
N = 1; L = 1;
x = linspace(0,2*N*L,N*400);

if mode == "square"
    n = (1:nCirc)*2-1;
    xFunc = @(n) 4/(n*pi) * cos(n*pi*x/L);
    yFunc = @(n) 4/(n*pi) * sin(n*pi*x/L);
elseif mode == "triangle"
    n = (1:nCirc)*2-1;
    xFunc = @(n) 4/(n^2*pi) * (-1)^((n-1)/2) * cos(n*pi*x/L);
    yFunc = @(n) 4/(n^2*pi) * (-1)^((n-1)/2) * sin(n*pi*x/L);
elseif mode == "sawtooth"
    n = (1:nCirc);
    xFunc = @(n) 4/(n*pi) * cos(n*pi*x/L);
    yFunc = @(n) 4/(n*pi) * sin(n*pi*x/L);
elseif mode == "absolutesin"
    n = (1:nCirc);
    xFunc = @(n) -12/(pi*(4*n^2-1)) * sin(2*n*pi*x/L);
    yFunc = @(n) -12/(pi*(4*n^2-1)) * cos(2*n*pi*x/L);
end

addsX = 0; addsY = 0;
for i = 1:length(n)
    valX = xFunc(n(i));
    valY = yFunc(n(i));
    addsX = addsX + valX(1);
    addsY = addsY + valY(1);
end

xCirc = zeros(length(n),length(x));
yCirc = zeros(length(n),length(x));
rCirc = zeros(length(n),2);

xCirc(1,:) = xFunc(n(1));
yCirc(1,:) = yFunc(n(1));

%% Affichage

subplot(1,2,1);
redP = plot(addsX,addsY,'or','MarkerFaceColor','r'); hold on; axis square;
shadow = plot(addsX,addsY,'Color',0.42*[1 1 1],'LineWidth',2); axis off;

ylim(4*[-1 1]);
xlim(4*[-1 1]);

for j = 1:nCirc
    circ(j) = plot(xCirc(1,:),yCirc(1,:),'k','LineWidth',1); %#ok<SAGROW>
    arms(j) = plot(         0,         0,'b','LineWidth',2); %#ok<SAGROW>
end

subplot(1,2,2);
traceY = plot(0,addsY,'k','LineWidth',2); axis square; axis off;
ylim(4*[-1 1]);
xlim([x(1) x(end)]); grid;


%% Update de l'affichage
for i = 1:length(x)
    for j = 2:nCirc
        xCirc(j,:) = xCirc(j-1,i) + xFunc(n(j));
        yCirc(j,:) = yCirc(j-1,i) + yFunc(n(j));
        rCirc(j,:) = [xCirc(j-1,i) yCirc(j-1,i)];
        
        set(  circ(j),'XData',               xCirc(j,:),'YData',               yCirc(j,:));
        set(arms(j-1),'XData',[rCirc(j,1) rCirc(j-1,1)],'YData',[rCirc(j,2) rCirc(j-1,2)]);
    end
    set(   redP,'XData',              xCirc(end,i) ,'YData',              yCirc(end,i) );
    set( traceY,'XData',        [traceY.XData x(i)],'YData',[traceY.YData yCirc(end,i)]);
    set( shadow,'XData',[shadow.XData xCirc(end,i)],'YData',[shadow.YData yCirc(end,i)]);
    set(arms(j),'XData',[xCirc(end,i) rCirc(end,1)],'YData',[yCirc(end,i) rCirc(end,2)]);
    
    drawnow
end
