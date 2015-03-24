
for i = 1:200
    for j = 1:200
        for k = 1:20
            img(i,j,k) = 64*rand;
            if (i-100)^2/90^2+(j-100)^2/80^2+(k-1)^2/16^2<1.1 && (i-100)^2/90^2+(j-100)^2/80^2+(k-1)^2/16^2>0.9 && j>40 && j<160
            img(i,j,k) = 127+128*(rand-.5); 
            end
        end
    end
end
img = uint8(img);
for j = 1:20
    if j == 1
        imwrite(img(:,:,j),'test.tif','tif','WriteMode','overwrite','Compression','none')
    else
        imwrite(img(:,:,j),'test.tif','tif','WriteMode','append','Compression','none')
    end
end