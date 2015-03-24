function problem_test
f2 = figure(2);
a2 = axes('Parent',f2);
p = plot(nan,nan,'r','Parent',a2);
f1 = figure(1);
set(f1,'WindowButtonDownFcn',@start_testfcn);
set(f1,'WindowButtonUpFcn',@stop_testfcn);
setappdata(f1,'Plots',p);
setappdata(f1,'Record',[]);

function start_testfcn(fh,e)
set(fh,'WindowButtonMotionFcn',@testfcn);

function stop_testfcn(fh,e)
set(fh,'WindowButtonMotionFcn',[]);

function testfcn(fh,e)
xy = get(0,'PointerLocation');
record = getappdata(fh,'Record');
record = [record; xy];
setappdata(fh,'Record',record);
p = getappdata(fh,'Plots');
set(p(1),'xdata',record(:,1),'ydata',record(:,2))