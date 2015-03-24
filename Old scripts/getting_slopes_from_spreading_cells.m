clearvars -except realspotsfirst
load('ColdblockEndfxyac.mat')
tpf = 1;

real = fxyac(1,5,:)==3;
qi = squeeze(fxyac(:,4,real));
qix = squeeze(fxyac(:,1,real));
qixpos  = squeeze(fxyac(:,2,real));
qiypos  = squeeze(fxyac(:,3,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
xpos = cell(size(qi,2),1);
ypos = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
    xpos{j} = qixpos(qi(:,j)>0,j);
    ypos{j} = qiypos(qi(:,j)>0,j);
end
%%
clearvars -except realspotssecond
load('ColdblockShort_750_R2.75.mat')
tpf = 1;

real = Threshfxyc(1,4,:)==3;
qi = squeeze(Threshfxyc(:,5,real));
qix = squeeze(Threshfxyc(:,1,real));
qixpos  = squeeze(Threshfxyc(:,2,real));
qiypos  = squeeze(Threshfxyc(:,3,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
xpos = cell(size(qi,2),1);
ypos = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
    xpos{j} = qixpos(qi(:,j)>0,j);
    ypos{j} = qiypos(qi(:,j)>0,j);
end
%%
joshcellspots = struct('start',[],'end',[],'x',[],'y',[],'amp',[]);
load('cb_sf.mat')
% xn = cell(1,length(x));
% yn = cell(1,length(y));
% init = zeros(length(x),1);
% life = zeros(length(x),1);
for k = 1:length(x)
    if ~isempty(x{k}) && ~isempty(y{k}) && ~isempty(start{k}) && ~isempty(finish{k})
        %xn{k} = x{k}(start{k}:finish{k});
        joshcellspots(k).amp = y{k}(start{k}:finish{k});
        joshcellspots(k).start = x{k}(start{k});
        joshcellspots(k).end = x{k}(finish{k});
        joshcellspots(k).x = xpos{k}(start{k});
        joshcellspots(k).y = ypos{k}(start{k});
    end
end
%%
clearvars
load('JoshCell3_750_updated.mat')
tpf = 3;

real = Threshfxyc(1,4,:)==3 | Threshfxyc(1,4,:)==1;
qi = squeeze(Threshfxyc(:,5,real));
qix = squeeze(Threshfxyc(:,1,real));
qixpos  = squeeze(Threshfxyc(:,2,real));
qiypos  = squeeze(Threshfxyc(:,3,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
xpos = cell(size(qi,2),1);
ypos = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
    xpos{j} = qixpos(qi(:,j)>0,j);
    ypos{j} = qiypos(qi(:,j)>0,j);
end
%%
joshcellspots = struct('start',[],'end',[],'x',[],'y',[],'amp',[]);
load('jc_sf.mat')
 xn = cell(1,length(x));
% yn = cell(1,length(y));
% init = zeros(length(x),1);
% life = zeros(length(x),1);
for k = 1:length(x)
    if ~isempty(x{k}) && ~isempty(y{k}) && ~isempty(start{k}) && ~isempty(finish{k})
        xn{k} = x{k}(start{k}:finish{k});
        joshcellspots(k).amp = y{k}(start{k}:finish{k});
        joshcellspots(k).start = x{k}(start{k});
        joshcellspots(k).end = x{k}(finish{k});
        joshcellspots(k).x = xpos{k}(start{k});
        joshcellspots(k).y = ypos{k}(start{k});
    end
end
%%
F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
F1 = @(a,b,x)a*x.*(1-x).*exp(-b*x);
F3 = @(c,d,x)-c*x.*(x-1).*exp(d*(x-1));
c02 = [7 3 7 3];
low2 = [0 0 0 0];
high2 = [50 10 50 10];
h = waitbar(0);
for k = 1:length(xn)
    if isempty(xn{k}) || length(xn{k})<=4
        continue;
    end
    xx = (xn{k}-xn{k}(1))/(xn{k}(end)-xn{k}(1));
    yy = (joshcellspots(k).amp-min(joshcellspots(k).amp))/(max(joshcellspots(k).amp)-min(joshcellspots(k).amp));
    gfit = fit(xx, yy, F2, 'StartPoint', c02, 'Lower', low2, 'Upper', high2);
    coval = coeffvalues(gfit);
    f2y = F2(coval(1),coval(2),coval(3),coval(4),xx);
    f1y = F1(coval(1),coval(2),xx);
    f3y = F3(coval(3),coval(4),xx);
    ratio = max(f3y)/max(f1y);
    if ratio > 5
        mp1 = 1;
        [~,mp2] = max(f3y);
    elseif ratio>2 && ratio <= 5
        [~,mp1] = max(f1y);
        [~,mp2] = max(f3y);
    else
        mp1 = 1;
        [~,mp2] = max(f1y);
    end
    rise1(k) = f2y(mp2)*(max(joshcellspots(k).amp)-min(joshcellspots(k).amp))+min(joshcellspots(k).amp);
    rise2(k) = f2y(mp1)*(max(joshcellspots(k).amp)-min(joshcellspots(k).amp))+min(joshcellspots(k).amp);
    run1(k) = xn{k}(mp2);
    run2(k) =  xn{k}(mp1);
    slope(k) = (rise1(k)-rise2(k))/(run1(k)-run2(k));
    waitbar(k/length(xn))
    
end
close(h)