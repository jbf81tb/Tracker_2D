for i = 1:size(masks,3)
    subplot(ceil(sqrt(size(masks,3))),ceil(sqrt(size(masks,3))),i)
    imagesc(masks(:,:,i))
    hold on
    temp_good = false(1,length(oldspots{1}));
    for j = 1:length(oldspots{1})
        if ceil(oldspots{3}(j)) == i
            temp_good(j) = true;
        end
    end
    plot(oldspots{1}(temp_good),oldspots{2}(temp_good),'k+')
    temp_good = false(1,length(goodspots{1}));
    for j = 1:length(goodspots{1})
        if ceil(goodspots{3}(j)) == i
            temp_good(j) = true;
        end
    end
    plot(goodspots{1}(temp_good),goodspots{2}(temp_good),'w+')
    
end
%%
imagesc(sum(masks,3))
colormap(gray)
hold on
scatter(oldspots{1},oldspots{2},25,'r+')
scatter(goodspots{1},goodspots{2},25,'g+')
%%
        smasks = masks;
%%
        lvl = 1;
        for i = 1:size(smasks,1)
            for j = 1:size(smasks,2)
                if smasks(i,j,lvl)
                    smasks(i,j,lvl) = .5;
                end
            end
        end
        clear i j lvl
%%
[x,y,z] = meshgrid(1:size(smasks,2),1:size(smasks,1),1:size(smasks,3));
    %%

isosurface(x,y,z,smasks,.5);
%set(gca,'Zlim', [-30 45]);
h = get(gca,'Children');
set(h(2), 'FaceColor', [1 .55 .45]);
hold on
scatter3(oldspots{1}(~goodspots{4}),oldspots{2}(~goodspots{4}),100*ones(1,length(oldspots{1}(~goodspots{4}))),100,'ko','fill')
scatter3(goodspots{1},goodspots{2},100*ones(1,length(goodspots{1})),100,[0 .8 0] ,'fill')
view(0,90)
xl = get(gca, 'Xlim'); yl = get(gca,'YLim');
set(gca,'XTick', [], 'YTick', [], 'Position', [0 0 1 1])
set(gcf, 'Units', 'normalized', 'Position',[0 0 1080/1920*(xl(2)-xl(1))/(yl(2)-yl(1)) 1])
set(h(1),'Position',[1800 1800 600])
%%
view(0,90)
%%
