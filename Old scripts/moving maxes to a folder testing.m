filelist = ls;
filename = cell(size(filelist,1)-2,1);
for i = 3:size(filelist,1)
    tempname = '';
    for j = 1:size(filelist,2)
        if ~strcmp(filelist(i,j), ' ')
            tempname = strcat(tempname,filelist(i,j));
        end
    end
    filename{i-2} = tempname;
end

%%
for i = 1:21:length(filename)-1
movefile(filename{i},'./maxes')
end