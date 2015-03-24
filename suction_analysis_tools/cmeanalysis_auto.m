clear
folderlist = ls;
wd = pwd;
for i = 3:size(folderlist,1)
    tempname = '';
    for j = 1:size(folderlist,2)
        if ~strcmp(folderlist(i,j), ' ')
            tempname = strcat(tempname,folderlist(i,j));
        end
    end
    tempfol = dir(tempname);
    dirname{i-2} = strcat(folderlist(i,:),'\',tempfol(end).name);
end

for i = 1:size(dirname,2)
    cd(dirname{i})
    pause(.1)
    cmeAnalysis('Parameters', [1.45, 100, 16], 'condDir', pwd, 'chNames', {'ch1'}, 'markers', {'egfp'}, 'Master', 1);
    pause(.1)
    cd(wd)
    pause(.1)
end
