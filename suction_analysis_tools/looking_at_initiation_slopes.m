clear all
load('ColdblockShort_750_R2.75.mat')
tpf = 4;

initiations = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qi = squeeze(Threshfxyc(:,5,initiations));
qix = squeeze(Threshfxyc(:,1,initiations));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
m = cell(size(qi,2),1);
b = cell(size(qi,2),1);
xs = cell(size(qi,2),1);
X = cell(size(qi,2),1);
Y = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
    [m{j}, b{j}, xs{j}] = multi_region_finder_temp(x{j}, y{j}, tpf);
    if ~isnan(m{j})
        leng = zeros(length(m{j}),1);
        for i = 1:length(m{j})
            leng(i) = (xs{j}{i}(end)-xs{j}{i}(1))*sqrt(m{j}(i)^2+1);
        end
        [~, ind] = sort(leng, 'descend');
        X{j}(1) = xs{j}{1}(1);
        Y{j}(1) = m{j}(1)*xs{j}{1}(1)+b{j}(1);
        l = 2;
        for k = 1:length(m{j})
            i = ind(k);
            if k == 1
               for points = 1:4
               X{j}(l) = xs{j}{i}(1) + points*(xs{j}{i}(end)-xs{j}{i}(1))/5;
               Y{j}(l) = m{j}(i)*X{j}(l)+b{j}(i);
               l = l+1;
               end
            elseif k < floor(9*length(m{j})/10)
               for points = 1:2
               X{j}(l) = xs{j}{i}(1) + points*(xs{j}{i}(end)-xs{j}{i}(1))/3;
               Y{j}(l) = m{j}(i)*X{j}(l)+b{j}(i);
               l = l+1;
               end
            else
            X{j}(l) = mean(xs{j}{i});
            Y{j}(l) = m{j}(i)*X{j}(l)+b{j}(i);
            l = l + 1;
            end
        end
        X{j}(l) = xs{j}{end}(end);
        Y{j}(l) = m{j}(end)*xs{j}{end}(end)+b{j}(end);
        [X{j}, order] = sort(X{j});
        Y{j} = Y{j}(order);
    end
    
end
%%
warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
gauss_width = 5;
KER = gausswin(gauss_width)/sum(gausswin(gauss_width));
rsq_val = 0.98;

q = 0;
while(1)
syd = 3; num = q*2*syd; st=num+1; nd = st+2*syd-1;
figure(1);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
for i = st:nd
    if ~isnan(m{i})
        subplot(2, syd, i+1-st)
        plot(x{i},y{i},'.b')
        hold on
        for j = 1:length(X{i})
            %plot(xs{i}{j}, m{i}(j)*xs{i}{j}+b{i}(j), 'r')
            %plot(mean(xs{i}{j}), mean(m{i}(j)*xs{i}{j}+b{i}(j)), 'Marker', 'o', 'MarkerFaceColor', 'g')
            plot(X{i},Y{i},'r');
        end
        %title(sprintf('%i',i));
    end
    
        blurred=0;
        while(1)
            order=2;
            rsq=0;
            while(rsq<rsq_val && order<=10 && order<=length(y{i})-2)
                p = polyfit(x{i},y{i},order);
                yfit = polyval(p,x{i});
                yresid = y{i} - yfit;
                SSresid = sum(yresid.^2);
                SStotal = (length(y{i})-1) * var(y{i});
                rsq = 1 - SSresid/SStotal;
                order=order+1;
            end
            if(rsq<rsq_val && blurred<3)
                gY = conv(y{i},KER,'same');
                blurred=blurred+1;
                order = 2;
            else
                %if blurred, plot(x{i},gY,'rx'); end
                break;
            end
        end
        
        plot(x{i},yfit,'g');
        dp = (length(p)-1:-1:1).*p(1:end-1);
        rdp = roots(dp);
        cond = imag(rdp)==0 & real(rdp)>=x{i}(1) & real(rdp)<=x{i}(end);
        plot(rdp(cond),polyval(p,rdp(cond)), 'Marker', 'o', 'MarkerFaceColor', 'k', 'LineStyle', 'none')
        cool_root_vals{i} = polyval(p,rdp(cond));
        
        
        title(sprintf('%i ~ %f ~ %i ~ %i',i, rsq, order-1, blurred-1));
end
pause
close(gcf)
q = q+1;
end

%%
k = 1; %#ok<UNRCH>
figure(1);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
for i = q
    if ~isnan(m{i})
        subplot(3, 4, k)
        plot(x{i},y{i},'.b')
        hold on
        for j = 1:length(xs{i})
            plot(xs{i}{j}, m{i}(j)*xs{i}{j}+b{i}(j), 'r')
        end
        title(sprintf('%i',i));
    end
    k = k+1;
end