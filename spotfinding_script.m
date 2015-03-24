pixel_size = 0.160;
stack_size = 0.500;
cf = 0.7;
%%
if ~exist('skip','var')
    skip = false;
end

if exist('scale','var')
    if ~skip, [X, Y, Z, scale] = spotfinder_3D('MAX_pits.tif',5,scale); end
else
    [X, Y, Z, scale] = spotfinder_3D('MAX_pits.tif');
end

if exist('thresh','var')
    if ~skip, [masks, thresh] = thresholding_development('membrane.tif','n',thresh); end
else
    [masks, thresh] = thresholding_development('membrane.tif');
end

oldspots = cell(1,3);
oldspots{1} = X; oldspots{2} = Y; oldspots{3} = Z;
%%
lim = 4;
good = false(1,length(X));
for i = 1:length(X)
    x = ceil(Y(i));
    y = ceil(X(i));
    z = ceil(Z(i));
    if (x>0&&x<size(masks,1)) && (y>0&&y<size(masks,2)) && (z>0&&z<size(masks,3))
    if masks(x,y,z) == 1
        for j = x-lim:x+lim
            for k = y-lim:y+lim
                for l = z-floor(lim/2):z+floor(lim/2)
                    if l<=0 || l>size(masks,3)
                        good(i) = true;
                    end
                    if (j>0&&j<=size(masks,1)) && (k>0&&k<=size(masks,2)) && (l>0&&l<=size(masks,3)) 
                    if abs(masks(j,k,l) - 0.5) < 0.01 || masks(j,k,l) == 0;
                    if sqrt((j-Y(i))^2 + (k-X(i))^2 + (l-Z(i))^2) < lim
                        good(i) = true;
                    end
                    end
                    end
                end
            end
        end
    end
    end
end

goodspots = cell(1,4);
goodspots{1} = X(good); goodspots{2} = Y(good); goodspots{3} = Z(good); goodspots{4} = good;
%%
lim = 15;
dens = zeros(size(goodspots{1}));
h = waitbar(0,'Finding densities...');
for i = 1:length(goodspots{1})
    x = ceil(goodspots{2}(i));
    y = ceil(goodspots{1}(i));
    z = ceil(goodspots{3}(i));
    if masks(x,y,z) == 1
        for j = x-lim:x+lim
            for k = y-lim:y+lim
                for l = z-floor(lim/2):z+floor(lim/2)
                    if (j>0&&j<size(masks,1)) && (k>0&&k<size(masks,2)) && (l>0&&l<size(masks,3))
                        for m = 1:length(goodspots{1})
                            if j == ceil(goodspots{2}(m)) && k == ceil(goodspots{1}(m)) && l == ceil(goodspots{3}(m))
                                dens(i) = dens(i) + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    
    surf_pts = false(1,length(pv.vertices));
    for j = 1:length(pv.vertices)
        if sqrt((pv.vertices(j,1)-goodspots{1}(i))^2 + (pv.vertices(j,2)-goodspots{2}(i))^2)<15
            surf_pts(j) = true;
        end
    end
    SurfAr = 0;
    for m = 1:size(pv.faces,1)
    if surf_pts(pv.faces(m,1)) && surf_pts(pv.faces(m,2)) && surf_pts(pv.faces(m,3))
    x1(1) = pixel_size*pv.vertices(pv.faces(m,1),1); x1(2) = pixel_size*pv.vertices(pv.faces(m,1),2); x1(3) = cf*stack_size*pv.vertices(pv.faces(m,1),3);
    x2(1) = pixel_size*pv.vertices(pv.faces(m,2),1); x2(2) = pixel_size*pv.vertices(pv.faces(m,2),2); x2(3) = cf*stack_size*pv.vertices(pv.faces(m,2),3);
    x3(1) = pixel_size*pv.vertices(pv.faces(m,3),1); x3(2) = pixel_size*pv.vertices(pv.faces(m,3),2); x3(3) = cf*stack_size*pv.vertices(pv.faces(m,3),3);
    SurfAr = SurfAr + 0.5*norm(cross((x2-x1),(x1-x3)));
    end
    end
    
    dens(i) = dens(i)/SurfAr;
    
    waitbar(i/length(goodspots{1}));
end
close(h)
%%
clearvars -except oldspots scale masks thresh goodspots dens pv
save('goodspots.mat')