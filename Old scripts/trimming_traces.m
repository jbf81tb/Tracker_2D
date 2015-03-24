function trimming_traces(Threshfxyc,tpf,outname)
%tpf = time per frame
%outname is the name of the output file to use for trace_ratios
real = Threshfxyc(1,4,:)==3 | Threshfxyc(1,4,:)==1;
qi = squeeze(Threshfxyc(:,5,real));
qix = squeeze(Threshfxyc(:,1,real));
x = cell(size(qi,2),1);
y = cell(size(qi,2),1);
for j = 1:size(qi,2)
    x{j} = qix(qi(:,j)>0,j)*tpf;
    y{j} = qi(qi(:,j)>0,j);
end

F1 = @(a,d,x)-a*x.*(x-1).*exp(d*(x-1));
F2 = @(a,b,c,d,x)a*x.*(1-x).*exp(-b*x)-c*x.*(x-1).*exp(d*(x-1));
c0 = [7 3]; c02 = [7 3 7 3];
low = [0 0]; low2 = [0 0 0 0];
high = [50 10]; high2 = [50 10 50 10];
gauss_width = 7;
KER = gausswin(gauss_width,3)/sum(gausswin(gauss_width));
gY = cell(3,1);
start = cell(length(x),1);
finish = cell(length(x),1);
h = waitbar(0);
    for k = 1:length(x)
        blurred = 1;
        gY{blurred} = y{k};
        while blurred <= 3
            if max(gY{blurred}) == gY{blurred}(1)
                break;
            end
            
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
                   start{k} = besti1;
                   finish{k} = besti2;
                break;
            end
            
            gY{blurred+1} = conv(gY{blurred},KER,'same');
            blurred = blurred+1;
        end
        waitbar(k/length(x));
    end
    close(h)
    save(outname,'start', 'finish');
end