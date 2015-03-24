
for i = 1:6
    num = 0;
    for j = 1:length(slope{i})
        if slope{i}(j)>0 && ~isinf(slope{i}(j)) 
            num = num + 1;
            scatx(num) = i;
            scaty{i}(num) = slope{i}(j);
        end
    end
    mn(i) = mean(slope{i}(slope{i}>0&~isinf(slope{i})));
end
clear i j num
%%
for i = 1:6
    plot([i-.2 i+.2], [mn(i) mn(i)], 'r');
end
%%
for i = 1:6
    num = 0;
    for j = 1:size(trimx,2)
        if ~isempty(trimx{i,j})
            num = num+1;
            lifex{i}(num) = trimx{i,j}(1);
            lifey{i}(num) = trimx{i,j}(end) - trimx{i,j}(1);
        end
    end
end
%%
for i = 1:6
    subplot(2,3,i)
    [q, qi] =  sort(lifex{i});
    plot(q,lifey{i}(qi),'.')
end