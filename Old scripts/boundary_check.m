for i = 1:stacks
    SHOW = J(:,:,i);
    figure('units','normalized','outerposition',[0 0 1 1]);
    imagesc(SHOW);    
    colormap('gray');
    hold on;
    plot(Vx(i,:),Vy(i,:),'r');
    hold off;
    waitforbuttonpress;
    close(gcf);
end