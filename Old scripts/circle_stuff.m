function [per1, per2, vol] = circle_stuff(circles)
numc = size(circles,4);
nums = size(circles,3);
vol = zeros(1,numc); per1 = zeros(1,numc); per2 = zeros(1,numc);
border = zeros(size(circles));
for l = 1:numc
    vol(l) = sum(sum(sum(circles(:,:,:,l))));

    for i = 1:nums
    [bx,by] = thresholding(circles(:,:,i,l),0);
        for j = 1:size(bx)
            border(by(j),bx(j),i,l) = 1;
        end
    end
end


for i = 1:nums
    

end

end