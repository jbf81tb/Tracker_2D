function buttonbug
close all; clc
set(gcf, 'WindowButtonDownFcn', @buttonDown,'HitTest','off');
title('Hit any key to exit');
switch waitforbuttonpress
    case 0
        disp('Mouse Button down detected')
    case 1
        disp('Key button down detected')
end 

function buttonDown(axisHandle, event)
disp('WindowButtonDownFcn callback executed')