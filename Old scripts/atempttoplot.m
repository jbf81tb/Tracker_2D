for i = 1:52
    if ~isempty(surfdat{1,2,i})
    trisurf(surfdat{1,1,i},surfdat{1,2,i}(:,1),surfdat{1,2,i}(:,2),surfdat{1,2,i}(:,3))
    hold on
    end
end