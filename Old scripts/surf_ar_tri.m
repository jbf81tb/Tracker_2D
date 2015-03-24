area = 0; x1 = zeros(size(K,1),3); x2 = zeros(size(K,1),3); x3 = zeros(size(K,1),3);
for i = 1:size(K,1)
x1 = X(K(i,1),:); x2 = X(K(i,2),:); x3 = X(K(i,3),:); 
area = area + 0.5*norm(cross((x2-x1),(x1-x3)));
end