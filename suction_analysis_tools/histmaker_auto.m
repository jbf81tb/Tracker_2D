function histmaker_auto(varargin)
if nargin == 1
    if varargin{1} ~= true, error('true:nottrue','Argument must be true or nothing'); end
    do_area = varargin{1};
else
    if exist('.\histmakerdata.mat','file')
        load('.\histmakerdata.mat','area')
        do_area = false;
    else
        disp('No area data. Doing area.')
        do_area = true;
    end
end
clearvars -except area do_area

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

frames = zeros(size(moviename,2),1);
if do_area, area = zeros(size(moviename,2),1); end
yi = cell(size(moviename,2),1);
xi = cell(size(moviename,2),1);
yc = cell(size(moviename,2),1);
xc = cell(size(moviename,2),1);
numtrace = zeros(size(moviename,2),1);
life = cell(size(moviename,2),1);
meanlife = cell(size(moviename,2),1);

for i = 1:size(moviename,2)
    load(tracename{i});
    fl(i) = str2double(dirname{i}(end-1)); %frame length
    
    real_test = Threshfxyc(1,4,:)==3;
    initiations = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==1|Threshfxyc(1,4,:)==5;
    conclusions = Threshfxyc(1,4,:)==3|Threshfxyc(1,4,:)==2|Threshfxyc(1,4,:)==2;
        qrt = squeeze(Threshfxyc(:,1,real_test));
        qi = squeeze(Threshfxyc(:,1,initiations));
        qc = squeeze(Threshfxyc(:,1,conclusions));
        
    frames = fl(i)*length(imfinfo(moviename{i}));
    binsize = 12;
    
    if do_area, area(i) = areavstime(moviename{i},frames/fl(i)); end
    
    [yi{i},xi{i}] = hist(fl(i)*qi(1,:),binsize/2:binsize:frames-binsize/2);
    yi{i} = yi{i}/area(i);
    xi{i} = xi{i};
    
    numtrace_conc = size(qc,2);
    conc = zeros(numtrace_conc,1);
    for j = 1:numtrace_conc
        conc(j) = fl(i)*qc(find(qc(:,j),1,'last'),j);
    end
    
    [yc{i},xc{i}] = hist(conc,binsize/2:binsize:frames-binsize/2);
    yc{i} = yc{i}/area(i);
    xc{i} = xc{i};
    
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
    qr = squeeze(Threshfxyc(:,1,real));
    
    numtrace(i) = size(qr,2);
    life{i} = zeros(numtrace(i),2);
    for j = 1:numtrace(i)
        life{i}(j,1) = qr(1,j);
        life{i}(j,2) = fl(i)*(qr(find(qr(:,j),1,'last'),j)-qr(1,j));
    end
    meanlife{i} = NaN(frames,1);
    for j=min(life{i}(:,1)):max(life{i}(:,1))
        dum1 = abs(life{i}(:,1)-j) <= 10;
        dum2 = life{i}(dum1,2);
        if isempty(dum2), dum2 = NaN; end
        meanlife{i}(j) = mean(dum2);
    end
end
save .\histmakerdata.mat area life meanlife xc xi yc yi fl legendname
clear
end