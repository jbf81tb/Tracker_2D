function [Area] = areavstime(filename, stacks)
step = ceil(stacks/36);
ss = imread(filename);
s = size(ss);
pixel_size = .160; %nm
gaus = fspecial('gaussian', 5, 1.5);
flat = ones(3)/9;
Area = zeros(1,stacks,'double');
J = zeros(s(1),s(2),stacks,'uint16');
IMG = zeros(s(1),s(2),stacks,'double');
for j = 1:stacks
    IMG(:,:,j) = imread(filename,'Index',j);
    J(:,:,j) = imfilter(IMG(:,:,j),gaus); %first gaussian filter
    J(:,:,j) = imfilter(IMG(:,:,j),flat); %then avg
end
SHOW = J(:,:,ceil(stacks/3));
    k = 0;
    while k ~= 1
        figure('units','normalized','outerposition',[0 0 1 1]);
        [y,x] = hist(double(SHOW(:)),100); %makes a historgram of intensities
        plot(x,y);
        axis tight;
        if k == 2, line([Thresh Thresh], [0 max(y)], 'Color', 'k'); end %allows an easier second guess
        title('Try an x pos after first peak.');
        [Thresh,~] = ginput(1);
        close(gcf);
        figure('units','normalized','outerposition',[0 0 1 1]);
        colormap('gray');
        for i = 1:step:stacks
            ah = subplot(6,6,(i-1)/step+1);
            imagesc(J(:,:,i));
            hold on; %draw the boundaries on top of the image
            [bx,by] = thresholding(J(:,:,i),Thresh); %see fcn at end
            plot(bx,by,'r');
            %{
            if max(by)==size(J(:,:,i),1) && max(bx) == size(J(:,:,i),2)
                hold on
                x = bx((abs(bx-max(bx))>2)&(abs(by-max(by))>2));
                y = by((abs(bx-max(bx))>2)&(abs(by-max(by))>2));
                circle = circlefind(x,y);
                rectangle('Position',[circle(1)-circle(3),circle(2)-circle(3),circle(1)+circle(3),circle(2)+circle(3)],'Curvature',[1 1],'EdgeColor','y');
            end
            %}
            axis off
            p = get(ah,'pos');
            p(1) = p(1) - 0.025;
            p(2) = p(2) - 0.020;
            p(3) = p(3) + 0.015;
            p(4) = p(4) + 0.015;
            set(ah, 'pos', p);
        end
        hold off;
        k = menu('Do you want to keep this?','Yes','No');
        close(gcf);
    end
    for i = 1:stacks
        [bx,by,mask] = thresholding(J(:,:,i),Thresh); %#ok<ASGLU>
        %x = bx((abs(bx-max(bx))>2)&(abs(by-max(by))>2));
        %y = by((abs(bx-max(bx))>2)&(abs(by-max(by))>2));
        %circle = circlefind(x,y);
        %if max(by)==size(J(:,:,i),1) && max(bx) == size(J(:,:,i),2)
        %Area(i) = pixel_size^2*pi*circle(3)^2;
        %else
            Area(i) = pixel_size^2*sum(mask(:));
        %end
    end
    Area = int32(mean(Area));
    %save('boundaries.mat','bx','by');
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

function circle = circlefind(x,y) %#ok<DEFNU>
p0(1) = mean(x);
p0(2) = mean(y);
p0(3) = 100;
options = optimset('Display','off','LargeScale','off');
circle = fminunc(@circ,p0,options,x,y);

function circ = circ(p,x,y)
cir = (x-p(1)).^2 + (y-p(2)).^2 - p(3)^2;
circ = sum(cir.^2);
end
end