function traces = fitting_of_manually_selected_hemocyte_pits
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
    moviename{i-ctr} = tempname;
    folders = dir(tempname);
    for j = 3:size(folders,1)
        filelist = dir(strcat(tempname,'\',folders(j).name));
        for k = 3:size(filelist,1)
            spotname{i-ctr, j-ctr, k-ctr} = strcat(wd,'\',tempname,'\',folders(j).name,'\',filelist(k).name);
            xydata{i-ctr, j-ctr, k-ctr} = filelist(k).name(1:end-4);
        end
    end
end
%%
traces = struct('MovieName','','TraceNumber','','Intensity',[],'X',[],'Y',[],'Frame',[],'Lifetime',[]);

l = 1;
for i = 1:size(spotname,1)
    for j = 1:size(spotname,2)
        if ~isempty(xydata{i,j,1})
        traces(l).MovieName = moviename{i};
        traces(l).TraceNumber = j;
        for k = 1:size(spotname,3)
            if ~isempty(xydata{i,j,k})
            filename = regexp(xydata{i,j,k},'\-','split');
            c = twoDgaussianFitting(spotname{i,j,k});
            %pause
            traces(l).Intensity(k) = c(2);
            traces(l).X(k) = c(3) - 3.5 + str2double(filename{2});
            traces(l).Y(k) = c(4) - 3.5 + str2double(filename{3});
            traces(l).Frame(k) = str2double(filename{1});
            end
        end
        traces(l).Lifetime = 5*(traces(l).Frame(end)-traces(l).Frame(1)+1);
        l = l+1;
        end
    end
end

end