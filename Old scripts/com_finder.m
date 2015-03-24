temp = sum(masks,3);
tmsk = zeros(size(masks));
for i = 1:size(masks,3)
    for j = 1:size(masks,1)
        for k = 1:size(masks,2)
            if temp(j,k)>4 && masks(j,k,i)>0
                tmsk(j,k,i) = 1;
            end
        end
    end
end

comaskx = zeros(size(tmsk));
for i = 1:size(tmsk,1)
    comaskx(i,:,:) = i*tmsk(i,:,:);
end
comx = sum(comaskx(:))/sum(tmsk(:));

comasky = zeros(size(tmsk));
for i = 1:size(tmsk,2)
    comasky(:,i,:) = i*tmsk(:,i,:);
end
comy = sum(comasky(:))/sum(tmsk(:));

comaskz = zeros(size(tmsk));
for i = 1:size(tmsk,3)
    comaskz(:,:,i) = i*tmsk(:,:,i);
end
comz = sum(comaskz(:))/sum(tmsk(:));

dist = zeros(size(goodspots{1}));
for i = 1:length(goodspots{1})
    dist(i) = sqrt((comx-goodspots{1}(i))^2 + (comy-goodspots{2}(i))^2 + (comz-goodspots{3}(i))^2);
end

clear comaskx comasky comaskz i j k temp 