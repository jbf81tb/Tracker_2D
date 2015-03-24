function image_motion_testing
figure('WindowButtonMotionFcn',@wbmcb)
img = imagesc(imread('cells004.tif'));
ah = get(img,'Parent');
pos = text('string','','VerticalAlignment','bottom','Color','w');
IMG = get(img,'CData');
function wbmcb(src,evnt) %#ok<INUSD>
    set(src,'Pointer','fullcross');
           cp = get(ah,'CurrentPoint');
           x = round(cp(1,1));
           y = round(cp(1,2));
           if(x>=1 && x<=size(IMG,2) && y>=1 && y<=size(IMG,1))
           set(pos,'string',sprintf('(%u,%u) %u',y,x,IMG(y,x)),'Position',[cp(1,1),cp(1,2)]);
           set(src,'WindowButtonDownFcn',@wbdcb);
           end
           
    function wbdcb(src,evnt)
        sprintf('x = %u \ny = %u',y,x)
    end
end
end