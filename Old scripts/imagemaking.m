close all
cellnum = 5;
cmap = colormap(hot);
temp = -sum(masks,3);
temp(temp==0) = -inf;
imagesc(temp)
colormap(gray)
hold on
h = scatter(goodspots{1},goodspots{2},300,cmap(ceil(64*dens/max(dens)),:), 'fill');
set(h,'MarkerEdgeColor', 'w', 'LineWidth', 2)
set(gca, 'Position', [0 0 1 1], 'Xlim', [croppings(cellnum,1) croppings(cellnum,2)], 'Ylim', [croppings(cellnum,3) croppings(cellnum,4)])
set(gcf, 'Units', 'normalized', 'Position', [0 0 1080/1920*(croppings(cellnum,2)-croppings(cellnum,1))/(croppings(cellnum,4)-croppings(cellnum,3)) 1])
%%
close all
cmap = colormap(jet);
imagesc(temp)
colormap(gray)
hold on
h = scatter(goodspots{1},goodspots{2},300,cmap(ceil(64*goodspots{3}/max(goodspots{3})),:),'fill');
set(h,'MarkerEdgeColor', 'w', 'LineWidth', 2)
set(gca, 'Position', [0 0 1 1], 'Xlim', [croppings(cellnum,1) croppings(cellnum,2)], 'Ylim', [croppings(cellnum,3) croppings(cellnum,4)])
set(gcf, 'Units', 'normalized', 'Position', [0 0 1080/1920*(croppings(cellnum,2)-croppings(cellnum,1))/(croppings(cellnum,4)-croppings(cellnum,3)) 1])