bord = [];
masks = padarray(masks,[1 1 1]);
for i = 2:size(masks,1)-1
    for j = 2:size(masks,2)-1
        for k = 2:size(masks,3)-1
            center = masks(i,j,k);
            east = masks(i+1,j,k);
            west = masks(i-1,j,k);
            north = masks(i,j+1,k);
            south = masks(i,j-1,k);
            up = masks(i,j,k+1);
            down = masks(i,j,k-1);
            if center
                if((east && ~west) || (west && ~east) || (north && ~south) || (south && ~north) || (up && ~down) || (down && ~up))
                bord = [bord;i j k];
                end
            end
        end
    end
end
border = unique(bord,'rows');
for i = 1:size(border,1)
masks(border(i,1),border(i,2),border(i,3)) = .5;
end