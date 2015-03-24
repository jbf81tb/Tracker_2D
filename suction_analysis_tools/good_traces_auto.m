function good_traces_auto
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
    legendname{i-ctr} = tempname;
    tempfol = dir(tempname);
    dirname{i-ctr} = strcat(wd,'\',folderlist(i,:),'\',tempfol(end).name);
    file = dir(strcat(dirname{i-ctr},'\ch1\'));
    for j = 1:size(file,1)
        if ~isempty(regexp(file(j).name,'tif', 'once')) && isempty(regexp(file(j).name,'traces', 'once'))
            moviename{i-ctr} = strcat(dirname{i-ctr},'\ch1\',file(j).name);
        end
    end
    tracename{i-ctr} = strcat(dirname{i-ctr},'\TempTraces.mat');
end

y = cell(size(moviename,2),1);
x = cell(size(moviename,2),1);
fl = zeros(size(moviename,2),1);
for i = 1:size(moviename,2)
    load(tracename{i});
    fl(i) = str2double(dirname{i}(end-1)); %frame length
    
    real_test = Threshfxyc(1,4,:)==3;
    qrt = squeeze(Threshfxyc(:,1,real_test));
                
    numtrace_test = size(qrt,2);
    life_test = zeros(numtrace_test,2);
    for j = 1:numtrace_test
        life_test(j) = find(qrt(:,j),1,'last') - 1;
    end
    meanlife_test = mean(life_test);
    
    re_ex = false(1,1,size(Threshfxyc,3));
    for j = 1:size(Threshfxyc,3)
        if Threshfxyc(1,4,j)==5||Threshfxyc(1,4,j)==6
            if find(Threshfxyc(:,1,j),1,'last')-1 < meanlife_test
                re_ex(1,1,j) = true;
            end
        end
    end
    
    real = logical((Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==6|Threshfxyc(1,4,:)==5) - re_ex);
    qix = fl(i)*squeeze(Threshfxyc(:,1,real));
    qi = squeeze(Threshfxyc(:,5,real));
    
    for j = 1:size(qi,2)
    x{i,j} = qix(qi(:,j)>0,j);
    y{i,j} = qi(qi(:,j)>0,j);
    end
end
save .\goodtraces.mat x y
clear
end