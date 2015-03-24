clear all
load('goodtraces.mat');
trimx = cell(size(x));
trimy = cell(size(y));
init = cell(size(x,1),1);
for cellnum = 1:6
    cnt = 0;
    load(sprintf('traces%i.mat',cellnum));
    for i = 1:length(new_x)
        if ~isempty(new_x{i})
            cnt = cnt+1;
            first = find(x{cellnum,i} == new_x{i}(1));
            last = find(x{cellnum,i} == new_x{i}(end));
            trimx{cellnum,i} = new_x{i};
            trimy{cellnum,i} = y{cellnum,i}(first:last);
            init{cellnum}(cnt) = new_x{i}(1);
        end
    end
end
clearvars -except trimx trimy init
%%
F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
F1 = @(a,b,x)a*x.*(1-x).*exp(-b*x);
F3 = @(c,d,x)-c*x.*(x-1).*exp(d*(x-1));
c02 = [7 3 7 3];
low2 = [0 0 0 0];
high2 = [50 10 50 10];
q = 0;

cellnum = 1;
numsize = 0;
for i = 1:size(trimx,2)
    if ~isempty(trimx{cellnum,i})
        numsize = numsize+1;
    end
end
while(1)
    syd = 5; num = q*syd*syd; st=num+1; nd = st+syd*syd-1;
    figure(1);
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    traces = ceil(rand(1,syd*syd)*numsize);
    spot = 0;
    for k = traces
        spot = spot+1;
        if ~isempty(trimx{cellnum,k})
            subplot(syd, syd, spot)
            xx = (trimx{cellnum,k}-trimx{cellnum,k}(1))/(trimx{cellnum,k}(end)-trimx{cellnum,k}(1));
            yy = (trimy{cellnum,k}-min(trimy{cellnum,k}))/(max(trimy{cellnum,k})-min(trimy{cellnum,k}));
            gfit = fit(xx, yy, F2, 'StartPoint', c02, 'Lower', low2, 'Upper', high2);
            %plot(xx, yy, '.');
            plot(trimx{cellnum,k},trimy{cellnum,k},'.');
            hold on
            coval = coeffvalues(gfit);
            f2y = F2(coval(1),coval(2),coval(3),coval(4),xx);
            f1y = F1(coval(1),coval(2),xx);
            f3y = F3(coval(3),coval(4),xx);
            ratio = max(f3y)/max(f1y);
            if ratio > 5
                mp1 = 1;
                [~,mp2] = max(f3y);
                titl = '1';
            elseif ratio>2 && ratio <= 5
                [~,mp1] = max(f1y);
                [~,mp2] = max(f3y);
                titl = '2';
            else
                mp1 = 1;
                [~,mp2] = max(f1y);
                titl = '3';
            end
            %plot([(mp1) xx(mp2)], [f2y(mp1) f2y(mp2)], 'k', 'LineWidth', 2);
            plot([trimx{cellnum,k}(mp1) trimx{cellnum,k}(mp2)],...
                [f2y(mp1)*(max(trimy{cellnum,k})-min(trimy{cellnum,k}))+min(trimy{cellnum,k}),...
                f2y(mp2)*(max(trimy{cellnum,k})-min(trimy{cellnum,k}))+min(trimy{cellnum,k})], 'k', 'LineWidth', 2);
            legend('off')
            %title(sprintf('%s ~ %12.4f',titl,ratio));
            xlabel(''); ylabel('');
            %set(gca,'XTick',[],'YTick',[])
        end
    end
    pause
    close(gcf)
    q = q+1;
end
%%
for i = 1:6
    %subplot(2,3,i)
    [why{i}, ex] = hist(init{i},min(init{i}):12:max(init{i}));
    %bar(ex, why)
    %hold on
    %plot([min(ex) max(ex)], [mean(why) mean(why)],'r')
    %legend('off')
end
%%
F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
F1 = @(a,b,x)a*x.*(1-x).*exp(-b*x);
F3 = @(c,d,x)-c*x.*(x-1).*exp(d*(x-1));
c02 = [7 3 7 3];
low2 = [0 0 0 0];
high2 = [50 10 50 10];
slope = cell(6,1);
h = waitbar(0);
for cellnum = 1:6
    for k = 1:size(trimx,2)
        if isempty(trimx{cellnum,k}) || length(trimx{cellnum,k})<=4
            continue;
        end
        xx = (trimx{cellnum,k}-trimx{cellnum,k}(1))/(trimx{cellnum,k}(end)-trimx{cellnum,k}(1));
        yy = (trimy{cellnum,k}-min(trimy{cellnum,k}))/(max(trimy{cellnum,k})-min(trimy{cellnum,k}));
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
        rise2{cellnum}(k) = f2y(mp2)*(max(trimy{cellnum,k})-min(trimy{cellnum,k}))+min(trimy{cellnum,k});
        rise1{cellnum}(k) = f2y(mp1)*(max(trimy{cellnum,k})-min(trimy{cellnum,k}))+min(trimy{cellnum,k});
        run2{cellnum}(k) = trimx{cellnum,k}(mp2);
        run1{cellnum}(k) = trimx{cellnum,k}(mp1);
        slope{cellnum}(k) = (rise2{cellnum}(k) - rise1{cellnum}(k))/(run2{cellnum}(k) - run1{cellnum}(k));
        waitbar(((cellnum-1)*size(trimx,2)+k)/(5*size(trimx,2)));
    end
end
close(h)
clearvars -except init trimx trimy slope