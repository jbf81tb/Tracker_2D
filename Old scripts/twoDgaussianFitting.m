function c = twoDgaussianFitting(imgfile)
% c(1) = background
% c(2) = amplitude
% c(3) = x center
% c(4) = y center
% c(5) = sd
if ischar(imgfile)
img = imread(imgfile);
else
img = imgfile;
end
[ydata, xdata] = meshgrid(1:size(img,2), 1:size(img,1));
F = @(back, amp, x0, y0, sd, x, y)back+amp*exp((-(x-x0).^2-(y-y0).^2)/(2*sd^2));
c0 = double([mean(min(img)) max(img(:))-mean(min(img)) ceil(size(img,2)/2) ceil(size(img,1)/2) 1]);
low = double([min(img(:)) mean(img(:))-min(img(:)) c0(3)-1 c0(4)-1 min(img(:))/max(img(:))]);
up = double([mean(img(:)) 1.1*(max(img(:))-min(img(:))) c0(3)+1 c0(4)+1 mean(size(img))]);
xdata = double(xdata); ydata = double(ydata); img = double(img);
gfit = fit([xdata(:), ydata(:)], img(:), F, 'StartPoint', c0, 'Lower', low, 'Upper', up);
%plot(gfit, [xdata(:), ydata(:)], img(:));
c = coeffvalues(gfit);
end