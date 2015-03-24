function [Volume, SurfAr] = artovol( filename, stacks, varargin)
%Area to Volume Ratio: Takes as input the filename, number of stacks, and thickness of stacks.
% The tif file given to this code must be arranged such that the first frame
% represents the bottom of the cell. There should also clearly only be one
% cell in the imaging field.
global pixel_size stack_size cf
if nargin == 2
    stack_size = 300; %nm
    pixel_size = 160; %nm
    tstacks = 1;
elseif nargin == 3
    stack_size = 300;
    pixel_size = 160;
    tstacks = varargin{1};
elseif nargin == 4
    tstacks = varargin{1};
    pixel_size = 160;
    stack_size = varargin{2};
elseif nargin == 5
    tstacks = varargin{1};
    pixel_size = varargin{3};
    stack_size = varargin{2};
end
ss = imread(filename);
s = size(ss);

gaus = fspecial('gaussian', 5, 1.5);
flat = ones(3)/9;
Volume = zeros(1,tstacks);
SurfAr = zeros(1,tstacks);
for n = 1:tstacks
    masks = zeros(s(1),s(2),stacks,'double');
    J = zeros(s(1),s(2),stacks,'uint16');
    IMG = zeros(s(1),s(2),stacks,'double');
    for j=1:stacks
        IMG(:,:,j) = imread(filename,'Index',j+(n-1)*stacks);
        J(:,:,j) = imfilter(IMG(:,:,j),gaus); %first gaussian filter
        J(:,:,j) = imfilter(IMG(:,:,j),flat); %then avg
    end
    
    SHOW1 = J(:,:,1);
    k = 0;
    while k ~= 1
        figure('units','normalized','outerposition',[0 0 1 1]);
        [y,x] = hist(double(SHOW1(:)),100); %makes a historgram of intensities
        plot(x,y);
        axis tight;
        if k == 2, line([Thresh Thresh], [0 max(y)], 'Color', 'k'); end %allows an easier second guess
        title('Try an x pos after first peak.');
        [Thresh,~] = ginput(1);
        close(gcf);
        figure('units','normalized','outerposition',[0 0 1 1]);
        colormap('gray');
        
        h = waitbar(0,'Loading...');
        for i = 1:stacks
            ah = subplot(ceil(sqrt(stacks)),ceil(sqrt(stacks)),i);
            imagesc(J(:,:,i));
            hold on; %draw the boundaries on top of the image
            [bx,by] = thresholding(J(:,:,i),Thresh); %see fcn at end
            plot(bx,by,'r');
            axis off
            p = get(ah,'pos');
            p(1) = p(1) - 0.025;
            p(2) = p(2) - 0.020;
            p(3) = p(3) + 0.015;
            p(4) = p(4) + 0.015;
            set(ah, 'pos', p);
            waitbar(i/stacks);
        end
        close(h);
        hold off;
        k = menu('Do you want to keep this?','Yes','No');
        close(gcf);
    end
    
    Area = zeros(1,stacks,'double');
    cf = 0.7; %correction factor for difference in medium
    
    for i = 1:stacks
        [bx,by,mask] = thresholding(J(:,:,i),Thresh);
        Area(i) = cf*stack_size*pixel_size^2*sum(sum(mask));
        if ~isempty(mask), masks(:,:,i) = mask; end
        for j = 1:size(bx)
            masks(by(j),bx(j),i) = .5;
        end
    end
    Volume(n) = sum(Area);
    masks = border3d(masks);
    [x,y,z] = meshgrid(1:size(masks,2),1:size(masks,1),1:size(masks,3));
    pv = isosurface(x,y,z,masks,.5);
    SurfAr(n) = surface(pv);
end
save('artovol.mat');
end

function [bx,by,mask] = thresholding(J,Thresh)
[B,L] = bwboundaries(J>Thresh,8,'noholes');
if size(B) ~=0
    a = [];
    for j = 1:size(B) %list out boundary sizes
        a = [a,size(B{j},1)]; %#ok<AGROW>
    end
    bound = find(a == max(a)); %get the biggest boundary shape
    if size(bound) == 1
        mask = (L==bound);
        mask = imfill(mask,'holes');
        by = B{bound}(:,1)';
        bx = B{bound}(:,2)';
    else
        bx = []; by = []; mask = [];
    end
else
    bx = []; by = []; mask = [];
end
end

function masks = border3d(masks)
bmasks = masks;
parfor i = 1:size(bmasks,1)
    tmasks = zeros(1,size(bmasks,2),size(bmasks,3));
    for j = 1:size(bmasks,2)
        for k = 2:size(bmasks,3)-1
            center = bmasks(i,j,k);
            up = bmasks(i,j,k+1);
            down = bmasks(i,j,k-1);
            if center && ((up && ~down) || (down && ~up) || (~up && ~down))
                tmasks(1,j,k) = .5;
            end
        end
    end
    masks(i,:,:) = masks(i,:,:) - tmasks(1,:,:);
end

for j = 1:size(masks,2)
    for k = 1:size(masks,1)
        if masks(k,j,1)
            masks(k,j,1) = .5;
        end
        if masks(k,j,end)
            masks(k,j,end) = .5;
        end
    end
end
end

function SurfAr = surface(pv)
global pixel_size stack_size cf
SurfAr = 0;
for m = 1:size(pv.faces,1)
    x1(1) = pixel_size*pv.vertices(pv.faces(m,1),1); x1(2) = pixel_size*pv.vertices(pv.faces(m,1),2); x1(3) = cf*stack_size*pv.vertices(pv.faces(m,1),3);
    x2(1) = pixel_size*pv.vertices(pv.faces(m,2),1); x2(2) = pixel_size*pv.vertices(pv.faces(m,2),2); x2(3) = cf*stack_size*pv.vertices(pv.faces(m,2),3);
    x3(1) = pixel_size*pv.vertices(pv.faces(m,3),1); x3(2) = pixel_size*pv.vertices(pv.faces(m,3),2); x3(3) = cf*stack_size*pv.vertices(pv.faces(m,3),3);
    SurfAr = SurfAr + 0.5*norm(cross((x2-x1),(x1-x3)));
end
end