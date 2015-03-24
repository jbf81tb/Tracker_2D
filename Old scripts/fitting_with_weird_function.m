clear all
load('ColdblockShort_750_R2.75.mat')
tpf = 4;

%initiations = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
real = Threshfxyc(1,4,:)==3;
qi = squeeze(Threshfxyc(:,5,real));
qix = squeeze(Threshfxyc(:,1,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
end
%%
F1 = @(a,d,x)-a*x.*(x-1).*exp(d*(x-1));
F3 = @(a,d,x) a*x.*(1-x).*exp(-d*x);
F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
c0 = [7 3];
c02 = [7 3 7 3];
low = [0 0];
low2 = [0 0 0 0];
high = [50 10];
high2 = [50 10 50 10];
gauss_width = 7;
KER = gausswin(gauss_width,3)/sum(gausswin(gauss_width));
gY = cell(3,1);
start = cell(length(x),1);
finish = cell(length(x),1);

% q = 0;
% while(1)
%     syd = 4; num = q*syd*syd; st=num+1; nd = st+syd*syd-1;
%     figure(1);
%     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    for k = 1:length(x)
        blurred = 1;
        gY{blurred} = y{k};
        while blurred <= 3
            if max(gY{blurred}) == gY{blurred}(1)
                break;
            end
            
            %subplot(syd, syd, k+1-st)
            
            best = 0;
            besti = length(x{k});
            for i = length(x{k}):-1:floor(length(x{k})/4)
                if i <= 2, break; end
                xx = (x{k}(1:i)-x{k}(1))/(x{k}(i)-x{k}(1));
                yy = (gY{blurred}(1:i)-min(gY{blurred}(1:i)))/(max(gY{blurred}(1:i))-min(gY{blurred}(1:i)));
                [~, gof] = fit(xx, yy, F1, 'StartPoint', c0, 'Lower', low, 'Upper', high);
                if gof.rsquare>best
                    best = gof.rsquare;
                    besti = i;
                end
            end
            if best > 0.85
%                 xx = (x{k}(1:besti)-x{k}(1))/(x{k}(besti)-x{k}(1));
%                 yy = (gY{blurred}(1:besti)-gY{blurred}(1))/(max(gY{blurred}(1:besti))-gY{blurred}(1));
%                 gfit = fit(xx, yy, F1, 'StartPoint', c0, 'Lower', low, 'Upper', high);
%                 coval = coeffvalues(gfit);
%                 thisy = F1(coval(1),coval(2),xx);
%                 plot((x{k}(1:besti)-min(x{k}))/(max(x{k})-min(x{k})), thisy, 'r', (x{k}-min(x{k}))/(max(x{k})-min(x{k})),(gY{blurred}-min(gY{blurred}))/(max(gY{blurred})-min(gY{blurred})),'.')
%                 title(sprintf('%i ~ 1 ~ %i ~ %f', k, blurred-1, best));
                %blurred = inf;
                start{k} = 1;
                finish{k} = besti;
                break;
            end

            best2 = 0;
            besti2 = length(x{k});
            for i = length(x{k}):-1:floor(length(x{k})/4)
                if i <= 4, break; end
                xx = (x{k}(1:i)-x{k}(1))/(x{k}(i)-x{k}(1));
                yy = (gY{blurred}(1:i)-min(gY{blurred}(1:i)))/(max(gY{blurred}(1:i))-min(gY{blurred}(1:i)));
                [~, gof] = fit(xx, yy, F2, 'StartPoint', c02, 'Lower', low2, 'Upper', high2);
                if gof.rsquare>best2
                    best2 = gof.rsquare;
                    besti2 = i;
                end
            end
            best = 0;
            besti1 = 1;
            for i = 1:floor(length(x{k})/4)
                if besti2-i+1 <= 4, break; end
                if max(gY{blurred}(i:besti2)) == gY{blurred}(besti2), continue; end
                xx = (x{k}(i:besti2)-x{k}(i))/(x{k}(besti2)-x{k}(i));
                yy = (gY{blurred}(i:besti2)-min(gY{blurred}(i:besti2)))/(max(gY{blurred}(i:besti2))-min(gY{blurred}(i:besti2)));
                [~, gof] = fit(xx, yy, F2, 'StartPoint', c02, 'Lower', low2, 'Upper', high2);
                if gof.rsquare>best
                    best = gof.rsquare;
                    besti1 = i;
                end
            end
            if best > 0.85
%                 xx = (x{k}(besti1:besti2)-x{k}(besti1))/(x{k}(besti2)-x{k}(besti1));
%                 yy = (gY{blurred}(besti1:besti2)-min(gY{blurred}(besti1:besti2)))/(max(gY{blurred}(besti1:besti2))-min(gY{blurred}(besti1:besti2)));
%                 gfit = fit(xx, yy, F2, 'StartPoint', c02, 'Lower', low2, 'Upper', high2);
%                 coval = coeffvalues(gfit);
%                 thisy = F2(coval(1),coval(2),coval(3),coval(4),xx);
%                 plot((x{k}(besti1:besti2)-min(x{k}))/(max(x{k})-min(x{k})), thisy, 'g', (x{k}-min(x{k}))/(max(x{k})-min(x{k})),(gY{blurred}-min(gY{blurred}))/(max(gY{blurred})-min(gY{blurred})),'.')
%                 title(sprintf('%i ~ 2 ~ %i ~ %f', k, blurred-1, best2));
%                 blurred = inf;
                   start{k} = besti1;
                   finish{k} = besti2;
                break;
            end
            
            gY{blurred+1} = conv(gY{blurred},KER,'same');
            blurred = blurred+1;
%             if blurred == 4;
%                 plot((x{k}-min(x{k}))/(max(x{k})-min(x{k})),(gY{1}-min(gY{1}))/(max(gY{1})-min(gY{1})),'.');
%                 title('Failed after 3 blurs.');
%             end
        end
        k
    end
%     pause
%     close(gcf)
%     q = q+1;
% end