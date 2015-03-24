function [masks, Thresh] = thresholding_development(filename, varargin)
%%
if nargin < 1
    input('What is the filename (including extension) of the membrane surface color? ',filename);
    disp = 'n';
elseif nargin == 1
    disp = 'n';
elseif nargin == 2
    disp = varargin{1};
elseif nargin == 3
    disp = varargin{1};
    Thresh = varargin{2};
else
    error('Too many inputs.')
end
%%
gaus = fspecial('gaussian', 5, 1.5);
flat = ones(3)/9;
ss = imread(filename);
s = size(ss);
stacks = length(imfinfo(filename));
masks = zeros(s(1),s(2),stacks,'double');
J = zeros(s(1),s(2),stacks,'uint16');
IMG = zeros(s(1),s(2),stacks,'double');
for j=1:stacks
    IMG(:,:,j) = imread(filename,'Index',j);
    J(:,:,j) = imfilter(IMG(:,:,j),gaus); %first gaussian filter
    J(:,:,j) = imfilter(IMG(:,:,j),flat); %then avg
end

SHOW1 = J(:,:,floor(stacks/3));
%%
if ~exist('Thresh','var')
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
    
    for i = 1:stacks
        ah = subplot(ceil(sqrt(stacks)),ceil(sqrt(stacks)),i);
        imagesc(J(:,:,i));
        hold on; %draw the boundaries on top of the image
        [bx,by] = thresholding(J(:,:,i),Thresh); %see fcn at end
        for j = 1:length(bx)
            plot(bx{j},by{j},'r');
            hold on
        end
        axis off
        p = get(ah,'pos');
        p(1) = p(1) - 0.025;
        p(2) = p(2) - 0.020;
        p(3) = p(3) + 0.015;
        p(4) = p(4) + 0.015;
        set(ah, 'pos', p);
    end
    hold off;
    k = menu('Do you want to keep this?','Yes','No','Exit');
    close(gcf);
    if k == 3, clear; return; end
end
end
%%
for i = 1:stacks
    [bx,by,mask] = thresholding(J(:,:,i),Thresh);
    if ~isempty(mask)
        for k = 1:length(mask)
            if k == 1
                masks(:,:,i) = mask{k};
            else
                masks(:,:,i) = mask{k} + masks(:,:,i);
            end
            if k <= length(bx)
            for j = 1:length(bx{k})
                masks(by{k}(j),bx{k}(j),i) = .5;
            end
            end
        end
    end
end
%%
if disp == 'y'
    [x,y,z] = meshgrid(1:size(masks,2),1:size(masks,1),1:size(masks,3));
    isosurface(x,y,z,masks,.5);
end
end
