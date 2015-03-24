i = 0; j = 1;
meanvec = [];
while i < length(sortedinit)-1
    i = i+1;
    meanvec = [meanvec; sortedlife(i)];
    if abs(sortedinit(i+1)-sortedinit(i)) ~= 0
        meanlife(j,1) = sortedinit(i);
        meanlife(j,2) = mean(meanvec);
        meanvec = [];
        j = j+1;
    end
end
%%
i = 0; j = 1;
meanvec = [];
while i < length(sortedinit)-1
    i = i+1;
    meanvec = [meanvec; sortedslope(i)];
    if abs(sortedinit(i+1)-sortedinit(i)) ~= 0
        meanslope(j,1) = sortedinit(i);
        meanslope(j,2) = mean(meanvec);
        meanvec = [];
        j = j+1;
    end
end
%%
existingavglife = zeros(399,1);
existingavglifestd = zeros(399,1);
for i = 1:399
    meanvec = [];
    for j = 1:length(sortedinit)
        if 3*i >= sortedinit(j) && 3*i <= sortedend(j)
            meanvec = [meanvec; sortedlife(j)];
        end
    end
    existingavglife(i) = mean(meanvec);
    existingavglifestd(i) = std(meanvec);
end
%%
existingavgslope = zeros(399,1);
existingavgslopestd = zeros(399,1);
for i = 1:399
    meanvec = [];
    for j = 1:length(sortedinit)
        if 3*i >= sortedinit(j) && 3*i <= sortedend(j)
            meanvec = [meanvec; sortedslope(j)];
        end
    end
    existingavgslope(i) = mean(meanvec);
    existingavgslopestd(i) = std(meanvec);
end
%%
meanvec = 0; iter = 0;
for i = 1:length(meanlife)
    for j = 1:length(meanlife)
        if abs(meanlife(i,1)-meanlife(j,1)) <= 30
        meanvec = meanvec + meanlife(j,2);
        iter = iter+1;
        end
    end
        ralife(i,1) = meanlife(i,1);
        ralife(i,2) = meanvec/iter;
        meanvec = 0; iter = 0;
 end
%%
meanvec = 0; iter = 0;
for i = 1:length(meanslope)
    for j = 1:length(meanslope)
        if abs(meanslope(i,1)-meanslope(j,1)) <= 30
        meanvec = meanvec + meanslope(j,2);
        end
    end
        raslope(i,1) = meanslope(i,1);
        raslope(i,2) = mean(meanvec);
        meanvec = 0; iter = 0;
end