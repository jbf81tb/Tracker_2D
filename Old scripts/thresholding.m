function [bx,by,mask] = thresholding(J,Thresh)
   [B,L,N] = bwboundaries(J>Thresh,8,'holes');
   if size(B) ~=0
       
       p = zeros(size(B));
       c = zeros(size(B));
       for j = 1:N %list out boundary sizes
           p(j) = length(B{j});
       end
       for j = N+1:length(B)
           c(j) = length(B{j});
       end
       boundp = find(p >= mean(p(p>0))); %get the biggest boundaries of parents
       boundc = find(c>0); %save the children
       mask = cell(1,length(boundp)+length(boundc));  by = cell(1,length(boundp));  bx = cell(1,length(boundp));
       for j = 1:length(boundp)+length(boundc)
           if j<=length(boundp)
               mask{j} = (L==boundp(j));
               by{j} = B{boundp(j)}(:,1)';
               bx{j} = B{boundp(j)}(:,2)';
           elseif j > length(boundp)
               mask{j} = (L==boundc(j-length(boundp)));
           end
       end
   else
       bx = []; by = []; mask = [];
   end
end