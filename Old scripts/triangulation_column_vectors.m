    x = []; y = []; z = [];
for i = 1:nums 
    [bx,by] = thresholding(circle(:,:,i),0);
    x = [x bx];
    y = [y by];
    z = [z i*ones(size(bx))];
    end
X = [x' y' z'];