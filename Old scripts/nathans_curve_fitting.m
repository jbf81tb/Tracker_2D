clear all
load('ColdblockShort_750_R2.75.mat')
tpf = 4;

initiations = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
qi = squeeze(Threshfxyc(:,5,initiations));
qix = squeeze(Threshfxyc(:,1,initiations));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
end
%%
warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
gauss_width = 5;
KER = gausswin(gauss_width)/sum(gausswin(gauss_width));
rsq_val = 0.98;

q = 0;
while(1)
    syd = 3; num = q*syd*syd; st=num+1; nd = st+syd*syd-1;
    figure(1);
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for i = st:nd
        subplot(syd, syd, i+1-st)
        plot(x{i},y{i},'.')
        hold on
        blurred=0;
        while(1)
            order=2;
            rsq=0;
            while(rsq<rsq_val && order<=14 && order<=length(y{i})-2)
                clear xx yfit
                xx(1) = x{i}(1);
                for j = 1:length(x{i})-1
                    temp = linspace(x{i}(j),x{i}(j+1),11);
                    xx(10*j-8:10*j+1) = temp(2:end);
                end
                xx = xx';
                p = polyfit(x{i},y{i},order);
                yfit = polyval(p,xx);
                yresid = y{i} - yfit(1:10:end);
                SSresid = sum(yresid.^2);
                SStotal = (length(y{i})-1) * var(y{i});
                rsq = 1 - SSresid/SStotal;
                order=order+1;
            end
            if(rsq<rsq_val && blurred<=3)
                gY = conv(y{i},KER,'same');
                blurred=blurred+1;
                order = 2;
            else
                %if blurred, plot(x{i},gY,'rx'); end
                break;
            end
        end
        
        plot(xx,yfit,'g');
        title(sprintf('%i ~ %f ~ %i ~ %i',i, rsq, order-1, blurred));
        dp = (length(p)-1:-1:1).*p(1:end-1);
        ddp = (length(dp)-1:-1:1).*dp(1:end-1);
        dddp = (length(ddp)-1:-1:1).*ddp(1:end-1);
        rdp = roots(dp);
        cond = imag(rdp)==0 & real(rdp)>=x{i}(1) & real(rdp)<=x{i}(end);
        rdp = rdp(cond);
        for j = 1:length(rdp)
            if polyval(p,rdp(j))<.3*max(y{i})
                if polyval(ddp,rdp(j))>0
                    plot(rdp(j),polyval(p,rdp(j)),'rx')
                end
            end
        end
    end
    title(sprintf('%i',i))
    pause
    close(gcf)
    q = q+1;
end