writerObj = VideoWriter('voltosurf4.avi');
writerObj.FrameRate = 5;
open(writerObj);
x = []; y = [];
figure('Renderer','zbuffer','Color','k');
plot(Volume./SurfAr);
axis([0 46 700 1300])
set(gca,'NextPlot','replaceChildren','color','k','XColor','w','Box','off');
for i = 1:46
    x = [x i];
    y = [y Volume(i)/SurfAr(i)];
    plot(x,y,'y-o','MarkerFaceColor','y','MarkerSize',5);
    F(i) = getframe(gcf);
    writeVideo(writerObj,F(i))
end
close(writerObj);