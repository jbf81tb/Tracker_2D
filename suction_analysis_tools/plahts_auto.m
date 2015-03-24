function plahts_auto(afters, varargin)
load('histmakerdata.mat')
color = 'ymcrgbk';
clear x y f i j k xp

if nargin == 0
    error('args:any','Must contain at least one argument. A numerical vector that corresponds to the movies you want to observe.')
end                     

if nargin == 1
    do_fits = input('Plot fits? (true or false): ');
    do_both = false;
elseif nargin == 2
    if ~islogical(varargin{1}), error('args:logical','First argument must be true or false'); end
    do_both = false;
    do_fits = varargin{1};
elseif nargin == 3
    befores = varargin{2};
    do_both = true;
    do_fits = varargin{1};
end


la = [];
figure('Name','Lifetimes - After','units','normalized','outerposition',[0 0 1 1])
for i = afters
    k = 0;
    for j = 1:length(meanlife{i})
        if ~isnan(meanlife{i}(j))
            k = k + 1;
            x(k) = k*fl(i);
            xp(j) = j*fl(i);
            y(k) = meanlife{i}(j);
        else
            xp(j) = NaN;
        end
    end
    if do_fits
        f = fit(x',y','poly1');
        plot(f, color(mod((i),length(color))+1), xp, meanlife{i}, strcat('.',color(mod((i),length(color))+1)));
    else
        plot(xp, meanlife{i}, strcat('.',color(mod((i),length(color))+1)));
    end
    hold on
    la = [la; life{i}(:,2)];
    clear x y f i j k xp
end
yl = get(gca,'ylim');
ylim([0 yl(2)]);
legend(legendname{afters});

figure('Name', 'Initiations - after', 'units','normalized','outerposition',[0 0 1 1])
for i = afters
    subplot(ceil(sqrt(length(afters))),ceil(sqrt(length(afters))),(i-afters(1))/(afters(2)-afters(1))+1)
    bar(xi{i},yi{i},'histc')
    xl = get(gca,'xlim');
    hold on
    plot([xl(1) xl(2)],[1 1]*mean(yi{i}),'r-')
    plot([xl(1) xl(2)],[1 1]*(mean(yi{i})+std(yi{i})),'g--')
    plot([xl(1) xl(2)],[1 1]*(mean(yi{i})-std(yi{i})),'g--')
    hold off
end
figure('Name', 'Conclusions - after', 'units','normalized','outerposition',[0 0 1 1])
for i = afters
    subplot(ceil(sqrt(length(afters))),ceil(sqrt(length(afters))),(i-afters(1))/(afters(2)-afters(1))+1)
    bar(xc{i},yc{i},'histc')
    xl = get(gca,'xlim');
    hold on
    plot([xl(1) xl(2)],[1 1]*mean(yc{i}),'r-')
    plot([xl(1) xl(2)],[1 1]*(mean(yc{i})+std(yc{i})),'g--')
    plot([xl(1) xl(2)],[1 1]*(mean(yc{i})-std(yc{i})),'g--')
    hold off
end
    
if do_both
lb = [];
figure('Name', 'Lifetimes - before', 'units','normalized','outerposition',[0 0 1 1])
for i = befores;
    k = 0;
    for j = 1:length(meanlife{i})
        if ~isnan(meanlife{i}(j))
            k = k + 1;
            x(k) = k*fl(i);
            xp(j) = j*fl(i);
            y(k) = meanlife{i}(j);
        else
            xp(j) = NaN;
        end
    end
    if do_fits
        f = fit(x',y','poly1');
        plot(f, color(mod((i+1),length(color))+1), xp, meanlife{i}, strcat('.',color(mod((i+1),length(color))+1)));
    else
        plot(xp, meanlife{i}, strcat('.',color(mod((i+1),length(color))+1)));
    end
    hold on
    lb = [lb; life{i}(:,2)];
    clear x y f i j k xp
    
end
yl = get(gca,'ylim');
ylim([0 yl(2)]);
legend(legendname{befores});

figure('Name', 'Initiations - before', 'units','normalized','outerposition',[0 0 1 1])
for i = befores
    subplot(ceil(sqrt(length(befores))),ceil(sqrt(length(befores))),(i-befores(1))/(befores(2)-befores(1))+1)
    bar(xi{i},yi{i},'histc')
    xl = get(gca,'xlim');
    hold on
    plot([xl(1) xl(2)],[1 1]*mean(yi{i}),'r-')
    plot([xl(1) xl(2)],[1 1]*(mean(yi{i})+std(yi{i})),'g--')
    plot([xl(1) xl(2)],[1 1]*(mean(yi{i})-std(yi{i})),'g--')
    hold off
end
figure('Name', 'Conclusions - before', 'units','normalized','outerposition',[0 0 1 1])
for i = befores
    subplot(ceil(sqrt(length(befores))),ceil(sqrt(length(befores))),(i-befores(1))/(befores(2)-befores(1))+1)
    bar(xc{i},yc{i},'histc')
    xl = get(gca,'xlim');
    hold on
    plot([xl(1) xl(2)],[1 1]*mean(yc{i}),'r-')
    plot([xl(1) xl(2)],[1 1]*(mean(yc{i})+std(yc{i})),'g--')
    plot([xl(1) xl(2)],[1 1]*(mean(yc{i})-std(yc{i})),'g--')
    hold off
end
end

clear color yl do_fits befores afters
end