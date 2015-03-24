function grid = circle_generator(varargin)
if size(varargin) == 0
r = 10; 
else
    r = varargin{1};
end
gs = 2*r+3;
sx = rand; sy = rand; sz = rand;
if sx>=0.5, sx = 1; else sx = -1; end
if sy>=0.5, sy = 1; else sy = -1; end
if sz>=0.5, sz = 1; else sz = -1; end
cx = sx*rand; cy = sy*rand; cz = sz*rand;

grid = zeros(gs,gs,gs);
cx = cx+r+2; cy = cy+r+2; cz = cz+r+2;
for i = 1:gs
    for j = 1:gs
        for k = 1:gs
            grid(i,j,k) = (sqrt((double(i)-cx)^2 + (double(j)-cy)^2 + (double(k)-cz)^2)<=r);
        end
    end
end
end