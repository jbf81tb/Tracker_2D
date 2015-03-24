function window_motion_testing
x = []; y = [];
figure('WindowButtonMotionFcn',@wbmcb)
ah = axes('DrawMode','fast');
p = plot(nan,nan,'Parent',ah);
axis ([0 10 0 10])
post = text('string','Move');

function wbmcb(src,evnt)
           cp = get(ah,'CurrentPoint');
           x = [x cp(1,1)];
           y = [y cp(1,2)];
           set(p,'XData',x,'YData',y);
           set(post,'string',sprintf('(%f,%f)',cp(1,1),cp(1,2)),'Position',[cp(1,1),cp(1,2)]);
end
end