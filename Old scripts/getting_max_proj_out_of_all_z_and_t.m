function getting_max_proj_out_of_all_z_and_t (zsize, tsize)
mkdir('maxes');
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
IMG = cell(tsize,zsize);
for i = 1:tsize
    for j = 1:zsize
        IMG{i,j} = imread(filename{(i-1)*zsize+j});
    end
end
%%
for i = 1:size(IMG,1)
    for j = 1:size(IMG,2)
        tempIMG(:,:,j) = IMG{i,j};
    end
    maxIMG(:,:,i) = max(tempIMG,[],3);
end
%%
for j = 1:size(IMG,1)
    if j == 1
        imwrite(maxIMG(:,:,j),strcat('./maxes/',filename{(j-1)*zsize+1}(1:end-7),'_max.tif'),'tif','WriteMode','overwrite','Compression','none')
    else
        imwrite(maxIMG(:,:,j),strcat('./maxes/',filename{(j-1)*zsize+1}(1:end-7),'_max.tif'),'tif','WriteMode','append','Compression','none')
    end
end

end