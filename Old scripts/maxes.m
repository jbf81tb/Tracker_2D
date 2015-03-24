mx = zeros(5,3);
%%
cell_num = 1;
temp = sum(masks,3);
mx(cell_num,1) = max(temp(:))*.5*.7;
mx(cell_num,2) = max(dens);
mx(cell_num,3) = max(goodspots{3})*.5*.7;