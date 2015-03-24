temp = masks;
for i = 1:size(masks,3)
    temp(:,:,i) = i*masks(:,:,i)+0.001;
end
temp = sum(temp,3)./sum(masks+0.001,3);