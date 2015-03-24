function [m, b, xs] = multi_region_finder(x,y,tpf)
time_length = length(x)*tpf;
if time_length<36, m = NaN; b = NaN; xs = NaN; return; end
min_length = max(12,ceil(time_length/16));
min_size = ceil(min_length/tpf);
i1 = 1; i2 = 1;k = 1;
while i1<length(x)-(min_size-1)
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = i1:i1+min_size-1
        xsum = xsum + x(j);
        ysum = ysum + y(j);
        xsum2 = xsum2 + x(j)^2;
        ysum2 = ysum2 + y(j)^2;
        xysum = xysum + x(j)*y(j);
    end
    w = min_size;
    m_temp = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
    b_temp = (ysum - m_temp*xsum)/w;
    
    resid = zeros(length(x),1);
    for j = i1:length(x)
        resid(j) = (y(j)-(m_temp*x(j)+b_temp))^2;
    end
    for i2 = i1+min_size:length(x)-4
        if resid(i2)>mean(resid(i1:i1+min_size-1)) && resid(i2+1)>resid(i2) && resid(i2+2)>resid(i2) && (resid(i2+3)>resid(i2) || resid(i2+4)>resid(i2))
            i2 = i2-1; %#ok<FXSET>
            break
        end
    end
    if isempty(i2), i2 = length(x); end
    
    
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = i1:i2
        xsum = xsum + x(j);
        ysum = ysum + y(j);
        xsum2 = xsum2 + x(j)^2;
        ysum2 = ysum2 + y(j)^2;
        xysum = xysum + x(j)*y(j);
    end
    w = i2-i1+1;
    m(k) = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
    b(k) = (ysum - m(k)*xsum)/w;
    xs{k} = x(i1:i2);
    i1 = i2;
    k = k+1;
end
end