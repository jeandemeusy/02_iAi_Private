function displayCurve(x,y,rot,r,maxH,numSeg,rectDim,color,record,modulo,displayOldRect,fileName,fps)
rectHeight = rectDim(2);
rectWidth  = rectDim(1);

figure;
set(gcf, 'Position',  [100, 100, 1200, 700],'color','b')

for i = 1:length(x)
    plot(x(1:i),y(1:i),'w','LineWidth',1.5); axis equal; axis off; xlim([-maxH-3*r maxH+3*r]); ylim([-(numSeg+1)*r (numSeg+1)*r]); hold on;
    xi = [x(i)-rectWidth/2 x(i)+rectWidth/2 x(i)+rectWidth/2 x(i)-rectWidth/2];
    yi = [y(i)-rectHeight/2 y(i)-rectHeight/2 y(i)+rectHeight/2 y(i)+rectHeight/2];
    
    if mod(i-1,modulo)==0
        P = patch('XData',xi,'YData',yi,'EdgeColor',color,'FaceColor','none','LineWidth',1.5); 
        rotate(P,[0 0 1],rad2deg(rot(i)),[x(i) y(i) 0]);
        if displayOldRect, hold on;
        else               hold off;
        end
    end
    if record 
        F(i) = getframe(gcf); 
    else
        pause(.5/fps);
    end
end

if record
    for j = 1:fps
        F(i+j) = getframe(gcf);
    end
    writerObj = VideoWriter(fileName);
    writerObj.FrameRate = fps;
    open(writerObj);
    for i=1:length(F)
        writeVideo(writerObj, F(i));
    end
    close(writerObj);
end