function masks = border3d(masks)
bmasks = masks;
parfor i = 1:size(bmasks,1)
    tmasks = zeros(1,size(bmasks,2),size(bmasks,3));
    for j = 1:size(bmasks,2)
        for k = 2:size(bmasks,3)-1
            center = bmasks(i,j,k);
            up = bmasks(i,j,k+1);
            down = bmasks(i,j,k-1);
            if center==1 && ((up && ~down) || (down && ~up) || (~up && ~down))
                tmasks(1,j,k) = .5;
            end
        end
    end
    masks(i,:,:) = masks(i,:,:) - tmasks(1,:,:);
end