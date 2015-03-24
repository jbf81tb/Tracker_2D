clear initiations qi qix
folderlist = ls;
wd = pwd;
ctr = 2;
for i = 3:size(folderlist,1)
    tempname = '';
    for j = 1:size(folderlist,2)
        if ~strcmp(folderlist(i,j), ' ')
            tempname = strcat(tempname,folderlist(i,j));
        end
    end
    if length(tempname)>2 && strcmp(tempname(end-2:end),'mat'), ctr = ctr+1; continue; end
    tempfol = dir(tempname);
    dirname{i-ctr} = strcat(wd,'\',folderlist(i,:),'\',tempfol(end).name);    
    tracename{i-ctr} = strcat(dirname{i-ctr},'\TempTraces.mat');
end
load histmakerdata.mat fl
avg_init = cell(length(tracename),1);
for i = 1:length(tracename)
    clear slope init
    if isempty(tracename{i}), continue; end
    load(tracename{i})
    tpf = fl(i);
    
    initiations = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
    qi = squeeze(Threshfxyc(:,5,initiations));
    qix = squeeze(Threshfxyc(:,1,initiations));
    
    slope = cell(size(qi,2),1);
    intercept = cell(size(qi,2),1);
    xvalues = cell(size(qi,2),1);
    yvalues = cell(size(qi,2),1);
    for j = 1:size(qi,2)
        x = qix(qi(:,j)>0,j)*tpf;
        y = qi(qi(:,j)>0,j);
        [m, b, xs] = multi_region_finder(x, y, tpf);
        slope{j} = m;
        intercept{j} = b;
        xvalues{j} = xs;
        for k = 1:length(slope)
            yvalues{j}{k} = m(k).*xs{k}+b(k);
        end
    end
    
    init = cell(length(slope),1);
    for j = 1:length(slope)
        ctr = 0;
        start = mean(yvalues{j}{1});
        finish = mean(yvalues{j}{end});
        for k = 1:(length(slope{j})-1)
            if j == 1 && slope{j}(k) < .01*max(slope{j}), ctr = ctr+1; continue; end
            if slope{j}(k)>0, init{j}(k-ctr) = slope{j}(k); end
            if slope{j}(k)<0 && (slope{j}(k+1)<0 || k+1 == length(slope{j}))
                break; 
            else
                ctr = ctr + 1;
            end
        end
    end
    
    for k = 1:length(init)
        avg_init{i}(k) = mean(init{k});
    end
end
save avg_inits.mat avg_init
clear