function circle = circlefind(x,y)
p0(1) = 200;
p0(2) = 200;
p0(3) = 150;
options = optimset('Display','off','LargeScale','off');
circle = fminunc(@circ,p0,options,x,y);

function circ = circ(p,x,y)
cir = (x-p(1)).^2 + (y-p(2)).^2 - p(3)^2;
circ = sum(cir.^2);
end
end