function [xx, yy, m] = best_fit_approx_n( x, y, n )
%Smooth a function using straight line approximations.
%   Currently store a bunch of detailed variables, but
%   I only need it for the x intercept.
w = 2*n+1;
xx = zeros([1,length(x)+2*(n-1)]);
if n == 1
    xx = x;
else
xx(1) = x(1);
for i = 2:n
    xx(i) = xx(1) + (i-1)*(x(2)-x(1))/n;
end
for i = (n+1):length(x)+n-2
    xx(i) = x(i-n+1);
end
k = 1;
for i = length(x)+n-1:length(x)+2*(n-1)
    xx(i) = x(end-1) + k*(x(end)-x(end-1))/n;
    k = k + 1;
end
%{
xx = x(1);
for i = 1:(length(x)-1)
    if i <= n
        d = (x(i+1)-x(i))/(n+1-i);
    elseif i >= (length(x)-n)
        d = (x(i+1)-x(i))/(n-(length(x)-1-i));
    else
        d = 1;
    end
    
    xx = [xx (x(i)+d):d:x(i+1)];
end
%}
yy = spline(x,y,xx);

new_y = zeros([1,length(x)]);
m = NaN([1,length(x)]);
x_int = zeros([1,length(x)]);
r = zeros([1,length(x)]);

new_y(1) = y(1);
new_y(length(x)) = y(length(x));


i = 2;
for k = 1+n:length(xx)-n
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = (k-n):(k+n)
        xsum = xsum + xx(j);
        ysum = ysum + yy(j);
        xsum2 = xsum2 + xx(j)^2;
        ysum2 = ysum2 + yy(j)^2;
        xysum = xysum + xx(j)*yy(j);
    end
    
    if ysum2 == 0
        m(i)=0;new_y(i)=0;x_int(i)=0;r(i)=0;
    else
        sx = sqrt((xsum2-xsum^2/w)/(w-1));
        sy = sqrt((ysum2-ysum^2/w)/(w-1));
        if sx==0 || sy ==0
            m(i)=0;new_y(i)=0;x_int(i)=0;r(i)=0;
        else
            m(i) = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
            b = (ysum - m(i)*xsum)/w;
            new_y(i) = m(i)*xx(k)+b;
            x_int(i) = -b/m(i);
            r(i) = ((xysum-xsum*ysum/w)/((w-1)*sx*sy))^2;
        end
    end
    i=i+1;
end


dum = r>0.9;
for i = 1:length(dum)
    if (dum(i) == true && (x_int(i) > median(x_int(dum))+std(x_int(dum)) || x_int(i) < median(x_int(dum))-std(x_int(dum))))
        dum(i) = false;
    end
end
%scale = floor(mean(x_int(dum)));
end