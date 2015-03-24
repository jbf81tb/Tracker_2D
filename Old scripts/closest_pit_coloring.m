cellnum = 5;
smasks = masks(croppings(cellnum,3):croppings(cellnum,4),croppings(cellnum,1):croppings(cellnum,2),:);

[~, L] = bwboundaries(sum(smasks,3)>0);
%%
L = bw;
smasks = bw;
croppings(cellnum,:) = zeros(1,3);
goodspots{1} = x; goodspots{2} = y;
%%
closest_n = 3;
temp = inf(size(smasks,1),size(smasks,2),closest_n);
q = zeros(1,length(goodspots{1}));
for i = 1:size(smasks,1)
    for j = 1:size(smasks,2)
        if L(i,j)
            for k = 1:length(goodspots{1})
                q(k) = sqrt((i+croppings(cellnum,3)-goodspots{2}(k))^2 + (j+croppings(cellnum,1)-goodspots{1}(k))^2);
            end
            q = sort(q);
            for l = 1:closest_n
            temp(i,j,l) = q(l);
            end
        end
    end
end
%%
temp1 = mean(temp,3);
%%
temp2 = (temp(:,:,2)+temp(:,:,3))/2;
%%
imagesc(stemp);
%%
set(gca, 'Position', [0 0 1 1])
set(gcf, 'Units', 'normalized', 'Position', [0 0 1080/1920*(croppings(cellnum,2)-croppings(cellnum,1))/(croppings(cellnum,4)-croppings(cellnum,3)) 1])
%%
subplot(2,2,1)
imagesc(mean(temp,3))
subplot(2,2,2)
imagesc(temp(:,:,1))
subplot(2,2,3)
imagesc(temp(:,:,2))
subplot(2,2,4)
imagesc(temp(:,:,3))