function [m, b, xs] = multi_region_finder_temp(x,y,tpf)
time_length = length(x)*tpf;
if time_length<32, m = NaN; b = NaN; xs = NaN; return; end
min_length = max(16,ceil(time_length/12));
min_size = ceil(min_length/tpf);
i1 = 1; k = 1;
i2 = i1 + min_size - 1;
while i2 <= length(x)-4
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = i1:i2
        xsum = xsum + x(j);
        ysum = ysum + y(j);
        xsum2 = xsum2 + x(j)^2;
        ysum2 = ysum2 + y(j)^2;
        xysum = xysum + x(j)*y(j);
    end
    w = i2-i1+1;
    m_temp = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
    b_temp = (ysum - m_temp*xsum)/w;
    
    resid = zeros(length(x),1);
    for j = i1:length(x)
        resid(j) = (y(j)-(m_temp*x(j)+b_temp))^2;
    end
    mnres = mean(resid(i1:i2));
    if resid(i2+1)>mnres && resid(i2+2)>mnres && (resid(i2+3)>mnres || resid(i2+4)>mnres)
        m(k) = m_temp;
        b(k) = b_temp;
        xs{k} = x(i1:i2);
        i1 = i2;
        i2 = i2 + min_size-1;
        k = k+1;
        continue;
    end
    i2=i2+1;
    
end
if i2 > length(x) - 4
    i2 = length(x);
    xsum = 0; ysum = 0; xsum2 = 0; ysum2 = 0; xysum = 0;
    for j = i1:i2
        xsum = xsum + x(j);
        ysum = ysum + y(j);
        xsum2 = xsum2 + x(j)^2;
        ysum2 = ysum2 + y(j)^2;
        xysum = xysum + x(j)*y(j);
    end
    w = i2-i1+1;
    m_temp = (w*xysum - xsum*ysum)/(w*xsum2-xsum^2);
    b_temp = (ysum - m_temp*xsum)/w;
    m(k) = m_temp;
    b(k) = b_temp;
    xs{k} = x(i1:i2);
end

end