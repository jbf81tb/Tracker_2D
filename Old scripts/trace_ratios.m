function mp = trace_ratios(input,inputfile)

real = input(1,4,:)==3;
qi = squeeze(input(:,5,real));
qix = squeeze(input(:,1,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j);
    y{j} = qi(qi(:,j)>0,j);
end

spots = struct('time',[],'amp',[]);
load(inputfile) %contains start and finish variables from 'trimming_traces'
for k = 1:length(x)
    if ~isempty(x{k}) && ~isempty(y{k}) && ~isempty(start{k}) && ~isempty(finish{k})
        spots(k).time = x{k}(start{k}:finish{k});
        spots(k).amp = y{k}(start{k}:finish{k});
    end
end

F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
F1 = @(a,b,x)a*x.*(1-x).*exp(-b*x);
F3 = @(c,d,x)-c*x.*(x-1).*exp(d*(x-1));
c0 = [7 3 7 3];
low = [0 0 0 0];
high = [50 10 50 10];
h = waitbar(0);
mp = NaN(length(spots),3);
for k = 1:length(spots)
    if isempty(spots(k).time) || length(spots(k).time)<=4
        continue;
    end
    xx = (spots(k).time-spots(k).time(1))/(spots(k).time(end)-spots(k).time(1));
    yy = (spots(k).amp-min(spots(k).amp))/(max(spots(k).amp)-min(spots(k).amp));
    gfit = fit(xx, yy, F2, 'StartPoint', c0, 'Lower', low, 'Upper', high);
    coval = coeffvalues(gfit);
    f1y = F1(coval(1),coval(2),xx);
    f3y = F3(coval(3),coval(4),xx);
    ratio = max(f3y)/max(f1y);
    if ratio > 5
        [~,mp(k,2)] = max(f3y);
    else
        [~,mp(k,1)] = max(f1y);
        [~,mp(k,2)] = max(f3y);
    end
    mp(k,3) = length(xx);
    waitbar(k/length(spots))
end
close(h)