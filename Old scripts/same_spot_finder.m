Xl = []; Yl = []; Zl = [];
for i = 1:length(X)
    Xl = [Xl X{i}];
    Yl = [Yl Y{i}];
    Zl = [Zl Z{i}];
end

q = ceil(Xl); w = ceil(Yl);

match = cell(1,length(q));
test = true(1,length(q));
for i = 1:length(q)-1
    if test(i)
        for j = i+1:length(q)
            if q(i) == q(j) && w(i) == w(j)
                match{i} = [match{i} j];
                test(j) = false;
            end
        end
    end
end
%%
Xs = []; Ys = []; Zs = [];
for i = 1:length(Xl)
    if test(i)
        if ~isempty(match{i})
            Xs = [Xs mean(Xl([i match{i}]))];
            Ys = [Ys mean(Yl([i match{i}]))];
            Zs = [Zs mean(Zl([i match{i}]))];
        else
            Xs = [Xs Xl(i)];
            Ys = [Ys Yl(i)];
            Zs = [Zs Zl(i)];
        end
    end
end

clear i q w